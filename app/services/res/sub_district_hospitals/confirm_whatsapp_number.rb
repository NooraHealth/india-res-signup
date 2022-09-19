# this operation confirms a user's mobile_number as their official WhatsApp-containing number,and then calls the WaSignup operation to sign them up
# success and errors will be logged in sdh_whatsapp_number_confirmation.log

module Res
  module SubDistrictHospitals
    class ConfirmWhatsappNumber < Res::SubDistrictHospitals::Base

      attr_accessor :exotel_params, :res_user, :parsed_exotel_params

      def initialize(logger, exotel_params)
        super(logger)
        self.exotel_params = exotel_params
      end

      def call

        # parse exotel params to get a simple hash with details like
        self.parsed_exotel_params = ExotelWebhook::ParseExotelParams.(self.exotel_params)


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
          self.errors = "User has is not aprt of any program"
          return self
        end

        if self.res_user.language_preference_id.blank?
          self.errors = "User has not chosen language preference"
          return self
        end

        # sign the user up for WA based schedules if they have signed up
        if self.res_user.signed_up_to_whatsapp
          self.logger.info("User satisfies all conditions for WA onboarding")
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