module RchPortal
  class OnboardingController < ApplicationController

    skip_forgery_protection

    # this method of onboarding will be used by any external party that wants to add
    # records to our RCH database. The format of this endpoint will be fixed and authenticated
    def external

    end


    def qr_code

    end

    def sms

    end

    def ivr

    end


    # this is an endpoint that will be used to update a user's language through WA
    def update_language
      ::RchPortal::UpdateLanguage.(params)
      render json: { status: "success" }
    end

    private

    def parsed_turn_params
      params.permit!
      parsed_params = TurnWebhook::ParseTurnParams.(params)
    end

  end
end
