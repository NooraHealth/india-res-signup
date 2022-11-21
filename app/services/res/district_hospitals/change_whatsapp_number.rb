
# this operation takes the user's whatsapp number from the API and updates the user's
# 'whatsapp_number' field which will be used for WA Signups

module Res
  module Dh
    class ChangeWhatsappNumber < Res::Dh::Base

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

        # format the number based on the way in which they entered it
        self.whatsapp_number = format_whatsapp_number(self.whatsapp_number)
        return self if self.errors.present?

        retrieve_user
        if self.res_user.blank?
          self.res_user = User.create(mobile_number: self.parsed_exotel_params[:user_mobile],
                                      whatsapp_mobile_number: self.whatsapp_number)
        else
          self.res_user.update(whatsapp_mobile_number: self.whatsapp_number,
                               whatsapp_number_confirmed: true)
        end

        # call operation to signup user to WA using TextIt APIs
        if self.res_user.signed_up_to_whatsapp
          self.res_user.update(whatsapp_mobile_number: self.whatsapp_number)
          op = Res::Dh::WaSignup.(self.logger, self.exotel_params)
          if op.errors.present?
            self.errors = op.errors
          end
        end

        self
      end


      private

      def format_whatsapp_number(number)
        if number.length == 10
          "0#{number}"
        elsif number.length < 10
          self.errors = "Number is not of sufficient length"
          return number
        end
      end

      # this function updates the user's preferences based on the signup instruction
      def update_user_parameters
        unless self.res_user.update(
          language_preference_id: self.exophone.language_id,
          condition_area_id: self.exophone.condition_area_id,
          program_id: self.exophone.program_id
        )
          self.errors << self.res_user.errors.full_messages
        end
      end
    end
  end
end