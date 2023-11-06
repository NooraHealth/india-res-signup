module ResOnboarding
  class DemoController < ApplicationController

    def ccp_ivr_initialize_user
      op = Res::Onboarding::IvrInitialize.(self.logger, exotel_params)
      if op.errors.present?
        logger.warn("IVR initialization failed with the errors: #{op.errors.to_sentence}")
        render json: {errors: op.errors}
      else
        render json: {}
      end
    end


    def ccp_ivr_select_condition_area
      op = Res::Onboarding::IvrConditionAreaSelection.(self.logger, exotel_params)
      if op.errors.present?
        logger.warn("IVR Condition Area selection failed with the following errors: #{op.errors.to_sentence}")
        render json: {errors: op.errors}
      else
        render json: {}
      end
    end

    def ccp_ivr_select_language
      op = Res::Onboarding::IvrSelectLanguage.(self.logger, exotel_params)
      if op.errors.present?
        logger.warn("Language updation failed with the following errors: #{op.errors.to_sentence}")
      else
        render json: {}
      end
    end

    def ccp_qr_signup
      op = Res::Onboarding::QrSignup.(self.logger, qr_code_params)
      if op.errors.present?
        logger.warn("QR Signup failed with the errors: #{op.errors.to_sentence}")
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
      self.logger = Logger.new("#{Rails.root}/log/demo/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{params}")
    end

  end
end