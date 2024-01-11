# frozen_string_literal: true

module Tb
  class OnboardingController < Tb::Base

    before_action :initiate_logger

    # this creates a user from the TB database given by the government
    # It accepts parameters from a script/external service that will consume this endpoint
    def create
      op = TbRes::Onboarding::CreateUser.(logger, create_params)
      if op.errors.present?
        render json: {errors: op.errors}
      else
        render json: {success: true, user: op.tb_user, tb_profile: op.tb_user.tb_profile}
      end
    end


    # this acknowledges that the user signed up for our TB messages through WA message sent on Day 0
    # The API request will come in from Textit where we're using the webhook feature
    # to send back the user's details and update their signed_up_to_whatsapp flag
    # API params:
    # {
    #  "uuid": "e3f4b3e0-4b8c-4b8c-8b8c-8b8c8b8c8b8c",
    #  "urn": [
    #     "whatsapp:919999999999", "tel:919999999999"
    #  ],
    # }
    def acknowledge_wa_signup
      user = extract_user_from_textit_params

      if user.blank?
        # no need to log here because that is already happening in the custom method
        render json: {success: false}
        return
      end

      # update the user's flag, their textit UUID, and the date of onboarding
      user.update(signed_up_to_whatsapp: true, textit_uuid: uuid, whatsapp_onboarding_date: DateTime.now)
      self.logger.info("Successfully updated user #{mobile_number} as signed up to WA")
      render json: {success: true}
    end


    # this updates the fact that the user has explicitly selected their language
    # so that they're not asked this question again
    # API params:
    # {
    #  "uuid": "e3f4b3e0-4b8c-4b8c-8b8c-8b8c8b8c8b8c",
    #  "urn": [
    #     "whatsapp:919999999999", "tel:919999999999"
    #  ],
    #  "language": "eng"
    # }
    def acknowledge_language_selection
      user = extract_user_from_textit_params

      # no need to log here because that is already happening in the custom method
      if user.blank?
        render json: {success: false}
        return
      end

      # extract the language that the user selected
      lang_code = extract_language_from_textit_params
      language = Language.with_code(lang_code)
      if language.blank?
        self.logger.warn("Language not found with code: #{lang_code} from params: #{textit_params}")
      end

      user.update(language_selected: true, language_id: language&.id)
      self.logger.info("Successfully updated user #{user.mobile_number} as having selected their language")
      render json: {success: true}
    end


    # this action is called from Exotel when the user presses 1, indicating they
    # want to sign up for the WA service as well
    def whatsapp_signup_from_ivr
      op = TbRes::WhatsappSignupFromIvr.(logger, exotel_params)
      if op.errors.present?
        logger.warn("Whatsapp signup from IVR for user: #{op.tb_res_user.mobile_number} with errors: #{op.errors.to_sentence}")
        render json: {errors: op.errors}
      else
        logger.info("Whatsapp signup from IVR for user: #{op.tb_res_user.mobile_number} successful")
        render json: {success: true}
      end
    end


    # action called when the user unsubscribes from IVR
    # this action will update the user's signed_up_to_ivr flag to false, and update
    # the date of unsubscription
    def ivr_unsubscribe
      user = extract_user_from_ivr_params

      if user.blank?
        # no need to log here because that is already happening in the custom method
        render json: {success: false}
        return
      end

      user.update(signed_up_to_ivr: false, ivr_unsubscribe_date: DateTime.now)
      self.logger.info("Successfully updated user #{user.mobile_number} as unsubscribed from IVR")
      render json: {success: true}
    end


    # action called when a user unsubscribes from WhatsApp
    # Removal of the user from the Textit group will be handled by Textit,
    # this action will just update the flag for the respective user and log it
    def whatsapp_unsubscribe
      user = extract_user_from_textit_params

      if user.blank?
        # no need to log here because that is already happening in the custom method
        render json: {success: false}
        return
      end

      user.update(signed_up_to_whatsapp: false, whatsapp_unsubscribe_date: DateTime.now)
      self.logger.info("Successfully updated user #{user.mobile_number} as unsubscribed from WA")
      render json: {success: true}
    end


    private

    def extract_language_from_textit_params
      lang_code = textit_params["contact"]["language"]
      unless lang_code
        self.logger.warn("Language not found in params: #{textit_params}")
        return nil
      end
      lang_code
    end

    # this method extracts the user from Textit webhook params.
    # It returns the user if found, else returns nil
    def extract_user_from_textit_params
      urns = textit_params["contact"]["urn"]
      urn = urns.select { |urn| urn.include? "whatsapp" }

      if urn.first.blank?
        self.logger.warn("URN not found in params")
        return nil
      end

      mobile_number = urn.first.gsub("whatsapp:91", "")
      user = User.find_by mobile_number: "0#{mobile_number}"
      if user.blank?
        self.logger.warn("User not found with mobile number: #{mobile_number}")
        return nil
      end
      user
    end

    # this method extracts the user from Exotel's webhook params. We use the exotel param parser
    # to extract the user's mobile number from the params
    def extract_user_from_ivr_params
      parsed_params = ExotelWebhook::ParseExotelParams.(logger, exotel_params)
      mobile_number = parsed_params[:user_mobile]

      user = User.find_by mobile_number: mobile_number
      if user.blank?
        self.logger.warn("User not found in database with mobile number: #{mobile_number}")
        return nil
      end
      user
    end


    def create_params
      params.permit!
    end

    def exotel_params
      params.permit!
    end

    def textit_params
      params.permit!
    end

    def initiate_logger
      self.logger = Logger.new("#{Rails.root}/log/tb/onboarding/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{params.permit!}")
    end
  end
end
