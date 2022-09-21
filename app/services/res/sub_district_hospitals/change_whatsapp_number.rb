# this operation takes the user's whatsapp number from the API and updates the user's
# 'whatsapp_number' field which will be used for WA Signups

module Res
  module SubDistrictHospitals
    class ChangeWhatsappNumber < Res::SubDistrictHospitals::Base

      attr_accessor :exotel_params, :parsed_exotel_params, :res_user,
                    :whatsapp_number

      def initialize(logger, exotel_params)
        super(logger)
        self.exotel_params = exotel_params
      end

      def call

        # use hashie to make it simple to navigate the params object from exotel
        self.exotel_params = self.exotel_params.extend Hashie::Extensions::DeepFind

        # parse exotel params to get a simple hash with details like
        self.parsed_exotel_params = ExotelWebhook::ParseExotelParams.(self.exotel_params)

        # extract the number entered by the user into a separate variable
        self.whatsapp_number = self.exotel_params["digits"].gsub("\"", "")

        # find the user first, throw error if not
        self.res_user = User.find_by mobile_number: self.parsed_exotel_params[:user_mobile]
        if self.res_user.blank?
          self.errors = "User not found"
          return self
        end

        # validate if all attributes are present for the user to be onboarded on WA

        if self.res_user.condition_area_id.blank?
          self.errors = "User has not chosen condition area"
          return self
        end

        if self.res_user.program_id.blank?
          self.errors = "User has is not part of any program"
          return self
        end

        if self.res_user.language_preference_id.blank?
          self.errors = "User has not chosen language preference"
          return self
        end

        # call operation to signup user to WA using TextIt APIs
        if self.res_user.signed_up_to_whatsapp
          self.res_user.update(whatsapp_mobile_number: self.whatsapp_number)
          op = Res::SubDistrictHospitals::WaSignup.(self.logger, self.exotel_params)
          if op.errors.present?
            self.errors = op.errors
          end
        end

        self
      end
    end
  end
end