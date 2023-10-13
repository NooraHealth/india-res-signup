# this operation will deal with params that come from both
# Exotel as well as Ozonetel, and will use an adapter structure
# to decide how to parse the incoming parameters

# For now, the parameters will be sent the same way to both so we won't have to deal with
# differing parameters at the moment

# this will call Textit's APIs to update a user's language, IF it is different from
# the default selection that is stored in our database

module Res
  module Onboarding
    class IvrSelectLanguage < Res::Onboarding::Base

      attr_accessor :ivr_params, :logger, :parsed_exotel_params, :language,
                    :res_user

      def initialize(logger, ivr_params)
        super(logger)
        self.ivr_params = ivr_params
      end


      def call
        # first parse the parameters that are being sent from the IVR service
        self.parsed_exotel_params = ExotelWebhook::ParseExotelParams.(self.ivr_params)

        self.language = Language.with_code(self.parsed_exotel_params[:language_code])
        if self.language.blank?
          self.errors << "Language with ISO code: #{self.parsed_exotel_params[:language]} not found"
          return self
        end

        # now retrieve the user from ivr params
        retrieve_user_from_ivr_params(self.parsed_exotel_params[:user_mobile])

        if self.res_user.blank?
          self.errors << "User with number: #{self.parsed_exotel_params[:user_mobile]} not found in database"
          return self
        end

        # if the user's language is different from the one present in the database
        # update it in the database and also call Textit's APIs to update the user's
        # language preference. If not, do nothing
        if self.language&.id != self.res_user.language_preference_id
          self.res_user.update(language_preference_id: self.language.id, language_selected: true)
          fields = {
            "language_selected": (self.res_user.language_selected ? "1" : "0")
          }
          op = TextitRapidproApi::UpdateLanguage.({id:  self.res_user.id, fields: fields}, logger:  self.logger)
          if op.errors.present?
            self.errors = op.errors
            return self
          end
        end

        self
      end
    end
  end
end
