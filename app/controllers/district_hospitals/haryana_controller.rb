module DistrictHospitals
  class HaryanaController < ApplicationController

    attr_accessor :logger

    skip_forgery_protection

    before_action :initiate_logger

    def ivr_initialize_user
      op = Res::Onboarding::IvrInitialize.(self.logger, exotel_params)
      if op.errors.present?
        logger.warn("IVR initialization failed with the errors: #{op.errors.to_sentence}")
        render json: {errors: op.errors}
      else
        render json: {}
      end
    end

    def ivr_select_condition_area
      op = Res::Onboarding::IvrConditionAreaSelection.(self.logger, exotel_params)
      if op.errors.present?
        logger.warn("IVR Condition Area selection failed with the following errors: #{op.errors.to_sentence}")
        render json: {errors: op.errors}
      else
        render json: {}
      end

    end

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

    def exotel_params
      params.permit!
    end

    def qr_code_params
      params.permit!
    end

    def initiate_logger
      self.logger = Logger.new("#{Rails.root}/log/haryana/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{params.permit!}")
    end
  end
end
