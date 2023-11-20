module ResOnboarding
  class MadhyaPradeshController < ResOnboarding::Base

    # this endpoint orchestrates the missed call based onboarding mechanism that we have
    # in Maharashtra at the moment.
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

    # This action collects all users who call the number and initializes them to
    # the MCH Neutral campaign
    def ccp_ivr_initialize_user
      op = Res::Onboarding::IvrInitialize.(self.logger, exotel_params)
      if op.errors.present?
        logger.warn("IVR initialization failed with the errors: #{op.errors.to_sentence}")
        render json: {errors: op.errors}
      else
        render json: {}
      end
    end

    # this endpoint updates the users condition area and adds them to the respective
    # condition area in the MCH program
    def ccp_ivr_select_condition_area
      op = Res::Onboarding::IvrConditionAreaSelection.(self.logger, exotel_params)
      if op.errors.present?
        logger.warn("IVR Condition Area selection failed with the following errors: #{op.errors.to_sentence}")
        render json: {errors: op.errors}
      else
        render json: {}
      end

    end


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

    private

    private

    def exotel_params
      params.permit!
    end

    def qr_code_params
      params.permit!
    end

    def initiate_logger
      self.logger = Logger.new("#{Rails.root}/log/madhya_pradesh/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{params.permit!}")
    end

  end
end

