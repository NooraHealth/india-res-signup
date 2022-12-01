# this operation updates the language preferences of a user in the SNCU program
# The user is asked for their language preference only once in the start of the program

module Res
  module DistrictHospitals
    module UnicefSncu
      class UpdateLanguagePreference < Res::DistrictHospitals::Base

        attr_accessor :language_id, :parsed_exotel_params, :res_user, :exotel_params

        def initialize(logger, params)
          super(logger)
          self.exotel_params = params
          self.errors = []
        end


        def call
          self.parsed_exotel_params = ExotelWebhook::ParseExotelParams.(self.exotel_params)

          # extract the language preference and state of the user from the parameter called language in the params
          self.language_id = Language.id_for(self.exotel_params[:language].to_s)

          # extract user from DB
          self.res_user = User.find_by mobile_number: self.parsed_exotel_params[:user_mobile]
          if self.res_user.blank?
            self.errors << "User with mobile #{self.parsed_exotel_params[:user_mobile]} not found in DB"
            return self
          end

          if self.language_id.present?
            self.res_user.update(language_preference_id: self.language_id)

            # also call TextIt API to update the user's language preference
            # first check if the user is part of TextIt
            if check_user_on_textit
              op = TextitRapidproApi::UpdateLanguage.(id: self.res_user.id, logger: self.logger)
              if op.errors.present?
                self.errors += op.errors
                return self
              end
            end

            self.logger.info("Successfully updated user's preferences with mobile number #{self.res_user.mobile_number}")
          end

        end
      end
    end
  end
end
