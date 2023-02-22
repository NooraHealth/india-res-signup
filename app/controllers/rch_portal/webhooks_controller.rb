module RchPortal
  class WebhooksController < ApplicationController

    attr_accessor :logger

    skip_forgery_protection

    before_action :initiate_logger


    # this action will be triggered from TextIt whenever a user signs up through direct WA onboarding
    def acknowledge_wa_signup
      mobile_number = wa_acknowledgement_params[:mobile_number]
      user = User.find_by mobile_number: "0#{mobile_number}"
      if user.blank?
        self.logger.warn("User not found with mobile number: #{mobile_number}")
        render json: {success: false}
        return
      end
      user.update(signed_up_to_whatsapp: true)
      self.logger.info("Successfully updated user #{mobile_number} as signed up to WA")
      render json: {success: true}
    end



    private

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
