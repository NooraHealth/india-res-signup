# this class, similar to the one for condition area, acknowledges that a
# user's language preference has changed
# It updates the database, and optionally can call Textit's APIs to update language

module Res
  module Onboarding
    class AcknowledgeLanguageChange < Res::Onboarding::Base

      attr_accessor :language_params, :logger, :language, :res_user, :mobile_number

      def initialize(logger, language_params)
        super(logger)
        self.language_params = language_params
      end


      def call

        # based on the channel, extract the mobile number
        channel = self.language_params[:channel]

        self.language = Language.with_code(self.language_params[:language_code])
        if self.language.blank?
          self.errors << "Language with ISO code: #{self.parsed_exotel_params[:language]} not found"
          return self
        end

        # first extract the mobile number of the user
        self.mobile_number = extract_mobile_number(channel, language_params)
        if self.mobile_number.blank?
          self.errors << "Mobile number not found in params"
          return self
        end

        retrieve_user
        return self if self.errors.present?

        # if the user's language is different from the one present in the database
        # update it in the database
        # Not calling Textit's APIs now because this change is happening on Textit
        # If the channel is NOT textit, then we call Textit's APIs
        if self.language&.id != self.res_user.language_preference_id
          self.res_user.update(language_preference_id: self.language.id)
          unless channel == "textit"
            op = TextitRapidproApi::UpdateLanguage.(id:  self.res_user.id, logger:  self.logger)
            if op.errors.present?
              self.errors = op.errors
              return self
            end
          end
        end

        self
      end

      private

      def retrieve_user
        self.res_user = User.find_by mobile_number: self.mobile_number
        if self.res_user.blank?
          self.errors << "User with mobile #{self.mobile_number} not found!"
        end
      end
    end
  end
end
