# this operation confirms a user's mobile_number as their official WhatsApp-containing number,and then calls the WaSignup operation to sign them up

module Res
  module SubDistrictHospitals
    class ConfirmWhatsappNumber < Res::SubDistrictHospitals::Base

      attr_accessor :exotel_params, :res_user, :parsed_exotel_params

      def initialize(exotel_params)
        super()
        self.exotel_params = exotel_params
      end

      def call
        self.message_logger = Logger.new("#{Rails.root}/log/sub_district_hospitals_confirm_whatsapp_number.log")

        # parse exotel params to get a simple hash with details like
        self.parsed_exotel_params = ExotelApi::ParseExotelParams.(self.exotel_params)


        self.res_user = User.find_by mobile_number: self.parsed_exotel_params[:user_mobile]
        if self.res_user.blank?
          self.errors = "User not found"
          return self
        end

        # sign the user up for WA based schedules if they have signed up
        if self.res_user.signed_up_to_whatsapp
          op = Res::SubDistrictHospitals::WaSignup.(self.exotel_params)
          if op.errors.present?
            self.errors = op.errors
          end
        end
      end

    end
  end
end