# this operation understands the modalities the user wants to opt in for and updates the User model accordingly
# this particular operation is for modality selection through IVR

module Res
  module SubDistrictHospitals
    class IvrModalitySelection < Res::SubDistrictHospitals::Base

      attr_accessor :exotel_params, :parsed_exotel_params, :res_user, :modality

      def initialize(logger, exotel_params)
        super(logger)
        self.exotel_params = exotel_params
      end


      def call

        # parse exotel params to get a simple hash with details like
        self.parsed_exotel_params = ExotelWebhook::ParseExotelParams.(self.exotel_params)

        # extract the modality stored for the user
        self.modality = self.exotel_params[:modality]
        self.logger.info("Modality chosen by user: #{self.modality}")

        # check if the user already exists
        self.res_user = User.find_by mobile_number: self.parsed_exotel_params[:user_mobile]

        # if user doesn't exist, create them
        if self.res_user.blank?
          self.errors = "User not found in DB"
        else
          unless self.res_user.update(signed_up_to_whatsapp: (modality == "whatsapp" || modality == "all"),
                                      signed_up_to_ivr: (modality == "ivr" || modality == "all"))
            self.errors = self.res_user.errors.full_messages
          end
          self.logger.info("User found with mobile number: #{self.res_user.mobile_number}")
        end

        self
      end
    end
  end
end
