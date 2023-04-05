# this is a common controller for users across different states as of now because the actions
# here are agnostic to state. When they do diverge, we can define them within individual states

module RchPortal
  class WebhooksController < ApplicationController

    attr_accessor :logger

    skip_forgery_protection

    before_action :initiate_logger


    # this action will be triggered from TextIt whenever a user signs up through direct WA onboarding
    def acknowledge_wa_signup
      urns = wa_acknowledgement_params["urns"]
      uuid = wa_acknowledgement_params["uuid"]
      urn = urns.select { |urn| urn.include? "whatsapp" }
      if urn.first.blank?
        self.logger.warn("URN not found in params")
        render json: {success: false}
        return
      end
      mobile_number = urn.first.gsub("whatsapp:91", "")
      user = User.find_by mobile_number: "0#{mobile_number}"
      if user.blank?
        self.logger.warn("User not found with mobile number: #{mobile_number}")
        render json: {success: false}
        return
      end
      user.update(signed_up_to_whatsapp: true, textit_uuid: uuid)
      self.logger.info("Successfully updated user #{mobile_number} as signed up to WA")
      render json: {success: true}
    end


    # this endpoint accepts the webhook given to Exotel APIs and updates the onboarding attempts of the user by 1
    # The format of the params is as follows:
    # {"campaign_sid"=>"6438318c00f10c0df9f2969324f365c0173u", "call_sid"=>"d410ae3950da25f20c098d49147d173u", "status"=>"completed", "from"=>"+917730904655", "caller_id"=>"+914069179581", "duration"=>55, "legs"=>[{"id"=>"35b991a988244ffcbf12b72dd9e15711", "on_call_duration"=>47, "status"=>"completed"}], "date_created"=>"2023-03-30T17:41:31+05:30", "date_updated"=>"2023-03-30T17:42:26+05:30", "digits"=>"1", "controller"=>"rch_portal/webhooks", "action"=>"update_onboarding_attempts", "webhook"=>{"campaign_sid"=>"6438318c00f10c0df9f2969324f365c0173u", "call_sid"=>"d410ae3950da25f20c098d49147d173u", "status"=>"completed", "from"=>"+917730904655", "caller_id"=>"+914069179581", "duration"=>55, "legs"=>[{"id"=>"35b991a988244ffcbf12b72dd9e15711", "on_call_duration"=>47, "status"=>"completed"}], "date_created"=>"2023-03-30T17:41:31+05:30", "date_updated"=>"2023-03-30T17:42:26+05:30", "digits"=>"1"}}
    def update_ivr_onboarding_attempts
      op = RchPortal::UpdateIvrOnboardingAttempts.(logger, exotel_webhook_params)
      if op.errors.present?
        logger.warn("Profile update failed with errors: #{op.errors.to_sentence}")
        render json: {errors: op.errors}
      else
        logger.info("Updated onboarding attempts for user with mobile: #{op.rch_user.mobile_number}")
        render json: {success: true}
      end

    end


    private

    def exotel_webhook_params
      params.permit!
    end

    def wa_acknowledgement_params
      params.permit!
    end

    def initiate_logger
      self.logger = Logger.new("#{Rails.root}/log/rch_webhooks/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{params}")
    end
  end
end
