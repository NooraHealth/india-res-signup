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
    #
    def update_onboarding_attempts
      mobile_number = exotel_webhook_params[:from] || exotel_webhook_params[:number]
      mobile_number = mobile_number[3..(mobile_number.length)]
      user = User.find_by mobile_number: "0#{mobile_number}"
      if user.blank?
        self.logger.warn("User not found with mobile number: #{mobile_number}")
        render json: {success: false}
        return
      end
      user.update(onboarding_attempts: (user.onboarding_attempts + 1))
      self.logger.info("Successfully updated onboarding attempts for user: #{mobile_number}")
      render json: {success: true}
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
