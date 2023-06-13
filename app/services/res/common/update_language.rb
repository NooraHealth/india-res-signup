# this class will accept parameters from textit for updating the language of
# a particular user. The parameters will be sent from Textit's webhook which
# updates the language on this database
# # Parameters:
# # {
# #   "mobile_number": "",
# #   "language_code": "",
# #   "channel": "" # textit, turn etc.
# # }

module Res
  module Common
    class UpdateLanguage < Res::Common::Base

      attr_accessor :textit_params

      def initialize(logger, textit_params)
        super(logger)
        self.textit_params = textit_params
      end

      def call
        # based on the channel, extract the mobile number
        channel = self.textit_params[:channel]

        # first extract the mobile number of the user
        mobile_number = extract_mobile_number(channel, textit_params)
        if mobile_number.blank?
          self.errors << "Mobile number not found in params"
          return self
        end

        # first look for the language sent in the request
        iso_code = self.textit_params[:language_code]
        language = Language.find_by(iso_code: iso_code)
        if language.blank?
          self.errors << "Language not found in database"
          return self
        end

        # next look for the user
        user = User.find_by mobile_number: mobile_number
        if user.blank?
          self.errors << "User not found in database with mobile number: #{mobile_number}"
          return self
        end

        # now update the language for the user in the database
        if user.update(language_preference_id: language.id)
          self.errors = user.errors.full_messages
          return self
        end

        self
      end


    end
  end
end
