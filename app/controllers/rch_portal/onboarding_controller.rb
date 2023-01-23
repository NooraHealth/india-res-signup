module Rch
  class OnboardingController < ApplicationController

    def qr_code

    end

    def sms

    end

    private

    def parsed_turn_params
      params.permit!
      parsed_params = TurnWebhook::ParseTurnParams.(params)
    end

  end
end
