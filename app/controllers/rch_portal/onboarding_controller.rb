module RchPortal
  class OnboardingController < ApplicationController

    attr_accessor :logger

    skip_forgery_protection

    before_action :initiate_logger

    # TODO - implement token based authentication
    # before_action :authorize_token

    # endpoint for importing records onto our list of RCH records
    def import
      op = RchPortal::Import.(import_params)
      @result = op.result
      # TODO - render results object in json
    end

    # this action onboards a single user onto the RCH Program
    # by taking their details in a standardized format and saving it
    # onto the database
    def create
      op = RchPortal::CreateUser.(logger, rch_params)
      if op.errors.present?
        @errors = op.errors
        render 'create_failure'
      else
        @rch_user = op.rch_user
        render 'create_success'
      end
    end

    # this endpoint will handle all link-based signups that happens for users on the RCH portal
    # The link essentially sends users a custom message that triggers a stack on Turn, which will specify
    # the condition area, language and state of the user to onboard them onto the right campaign
    def link_based_signup

    end


    # this endpoint will handle all onboarding that are based off of IVR
    # Based on the exophone, the relevant program, condition area and language is chosen and users
    # are onboarded onto the specific program based on that
    def ivr
      op = RchPortal::IvrSignup.(logger, exotel_params)
      if op.errors.present?
        render json: {errors: op.errors}
      else
        render json: {}
      end
    end


    # this is an endpoint that will be used to update a user's language through WA
    # # TODO - Abhishek will implement this
    def update_language

    end

    private

    def parsed_turn_params
      params.permit!
      parsed_params = TurnWebhook::ParseTurnParams.(params)
    end

    def exotel_params
      params.permit!
    end

    def import_params
      params.permit!
    end

    def rch_params
      params.permit!
    end

    def initiate_logger
      self.logger = Logger.new("#{Rails.root}/log/rch/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{params}")
    end

  end
end