# This operation specifies the language of a user based on what they select in the IVR or WA message

module Res
  module SubDistrictHospitals
    class LanguageSelection < Res::SubDistrictHospitals::Base

      attr_accessor :exotel_params, :parsed_exotel_params, :res_user, :language_id

      def initialize(logger, exotel_params)
        super(logger)
        self.exotel_params = exotel_params
      end


      def call

        # parse exotel params to get a simple hash with details like
        self.parsed_exotel_params = ExotelWebhook::ParseExotelParams.(self.exotel_params)

        # extract the language preference of the user
        language_name =
        self.language_id = Language.id_for(self.exotel_params[:language].to_s)
        self.logger.info("Language selected is: #{self.exotel_params[:language].to_s}")

        # extract user from DB
        self.res_user = User.find_by mobile_number: self.parsed_exotel_params[:user_mobile]

        # if user doesn't exist, create them
        if self.res_user.blank?
          self.res_user = User.new(mobile_number: self.parsed_exotel_params[:user_mobile],
                                   incoming_call_date: Time.now,
                                   program_id: NooraProgram.id_for(:sdh),
                                   language_preference_id: self.language_id)
          unless self.res_user.save
            self.errors = self.res_user.errors.full_messages
          end
          self.logger.info("User created in DB with ID: #{self.res_user.id}")
        else
          self.res_user.update(language_preference_id: self.language_id)
          self.logger.info("User found with mobile number: #{self.res_user.mobile_number}")
        end

        self
      end
    end
  end
end
