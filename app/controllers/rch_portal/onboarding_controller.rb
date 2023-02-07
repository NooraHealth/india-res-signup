module RchPortal
  class OnboardingController < ApplicationController

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

    end


    def qr_code

    end

    def sms

    end

    def ivr

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

    def import_params
      params.permit!
    end

    def initiate_logger
      self.logger = Logger.new("#{Rails.root}/log/rch/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{params}")
    end

  end
end
