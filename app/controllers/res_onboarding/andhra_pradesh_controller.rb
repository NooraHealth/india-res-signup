# this controller will be the one that orchestrates all actions to do with RES in Andhra Pradesh
# This controller is unique in that the cloud telephony provider is Ozonetel and not Exotel

# All RES related actions as well as RCH related actions will be done here

# All states that have the standardized onboarding flow for RES will be using this controller
# 1. ccp_ivr_initialize_user - Creates the user on TextIt and onboards them on to the MCH Neutral Campaign
# 2. ccp_ivr_select_condition_area - Updates TextIt group based on condition area chosen by user
# 3. ccp_acknowledge_condition_area - Updates the condition area of a user based on their selection in WhatsApp

module ResOnboarding
  class AndhraPradeshController < ResOnboarding::Base

    def ccp_ivr_initialize_user
      op = Res::Onboarding::IvrInitialize.(self.logger, exotel_params)
      if op.errors.present?
        logger.warn("IVR initialization failed with the errors: #{op.errors.to_sentence}")
        render json: {errors: op.errors}
      else
        if op.existing_user
          render json: {result: 2}
        else
          render json: {result: 1}
        end
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


    def ccp_ivr_acknowledge_condition_area

    end


    # PLATFORM - Always from Turn
    # this endpoint will handle all link-based signups that happens for users on the RCH portal
    # The link essentially sends users a custom message that triggers a stack on Turn, which will specify
    # the condition area, language and state of the user to onboard them onto the right campaign
    def rch_link_based_signup
      op = RchPortal::LinkBasedSignup.(logger, turn_params)
      if op.errors.present?
        logger.warn("Link based signup failed with errors: #{op.errors.to_sentence}")
        render json: {success:false, errors: op.errors}
      else
        render json: {success: true}
      end
    end


    # TODO - TEMPORARILY ON EXOTEL, CHANGE TO OZONETEL

    # this endpoint will handle all onboarding that are based off of IVR
    # Based on the exophone, the relevant program, condition area and language is chosen and users
    # are onboarded onto the specific program based on that
    def rch_ivr_signup
      op = RchPortal::IvrSignup.(logger, exotel_params)
      if op.errors.present?
        logger.warn("IVR Signup failed with the errors: #{op.errors.to_sentence}")
        render json: {errors: op.errors}
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

    def turn_params
      params.permit!
    end

    def exotel_params
      params.permit!
    end

    def initiate_logger
      self.logger = Logger.new("#{Rails.root}/log/andhra_pradesh/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{turn_params}")
    end

  end
end
