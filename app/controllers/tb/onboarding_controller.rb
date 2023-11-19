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
    def acknowledge_wa_signup

    end


    # this updates the fact that the user has explicitly selected their language
    # so that they're not asked this question again
    def acknowledge_language_selection

    end


    # this action is called from Exotel when the user presses 1, indicating they
    # want to sign up for the WA service as well
    def ivr_signup_for_whatsapp

    end


    # action called when the user unsubscribes from IVR
    def ivr_unsubscribe

    end

    # action called when a user unsubscribes from WhatsApp
    def whatsapp_unsubscribe

    end


    private

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
