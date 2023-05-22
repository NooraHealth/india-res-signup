module DistrictHospitals
  class AndhraPradeshController < ApplicationController

    skip_forgery_protection

    before_action :initiate_logger

    def qr_signup
      op = Res::Onboarding::QrSignup.(self.logger, qr_code_params)
      if op.errors.present?
        logger.warn("QR Signup failed with the errors: #{op.errors.to_sentence}")
        render json: {success: false, errors: op.errors}
      else
        render json: {success: true}
      end
    end

    def acknowledge_condition_area
      op = Res::Onboarding::AcknowledgeConditionAreaChange.(self.logger, params.permit!)
      if op.errors.present?
        logger.warn("Updating condition area failed with the following errors: #{op.errors.to_sentence}")
        render json: {success: false, errors: op.errors}
      else
        render json: {success: true}
      end
    end


    private

    def qr_code_params
      params.permit!
    end

    def initiate_logger
      self.logger = Logger.new("#{Rails.root}/log/andhra_pradesh/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{params.permit!}")
    end
  end
end

