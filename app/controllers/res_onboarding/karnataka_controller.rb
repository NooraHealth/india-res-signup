# this controller contains all onboarding related actions for a user in Karnataka
# All RES and RCH related actions will be done here - i.e. all inbound and outbound actions
# for a user to signup for our service

# All states that have the standardized onboarding flow for RES will be using this controller
# 1. ccp_ivr_initialize_user - Creates the user on TextIt and onboards them on to the MCH Neutral Campaign
# 2. ccp_ivr_select_condition_area - Updates TextIt group based on condition area chosen by user
# 3. ccp_acknowledge_condition_area - Updates the condition area of a user based on their selection in WhatsApp


module ResOnboarding
  class KarnatakaController < ResOnboarding::Base

    # this endpoint orchestrates the missed call based onboarding mechanism that we have
    # in Karnataka at the moment.
    def ccp_dh_signup
      op = Res::DistrictHospitals::ExotelWaSignup.(logger, exotel_params)
      if op.errors.present?
        logger.info("Operation returned error: #{op.errors.to_sentence}")
        render json: {success: false, errors: op.errors.to_sentence}
        return
      end
      # for now return 200 if the user is successfully onboarded
      render json: {success: true}
    end



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

    def ccp_acknowledge_condition_area
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
      self.logger = Logger.new("#{Rails.root}/log/res/karnataka/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{params}")
    end

  end
end
