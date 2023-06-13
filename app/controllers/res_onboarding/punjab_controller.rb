# this controller contains all onboarding related actions for a user in Punjab
# All RES and RCH related actions will be done here - i.e. all inbound and outbound actions
# for a user to signup for our service

# All states that have the standardized onboarding flow for RES will be using this controller
# 1. ccp_ivr_initialize_user - Creates the user on TextIt and onboards them on to the MCH Neutral Campaign
# 2. ccp_ivr_select_condition_area - Updates TextIt group based on condition area chosen by user
# 3. ccp_acknowledge_condition_area - Updates the condition area of a user based on their selection in WhatsApp

module ResOnboarding
  class PunjabController < ResOnboarding::Base

    # this endpoint handles the missed call based signup mechanism that we have for
    # DHs in Punjab. As soon as the user calls this number, they will be added to the respective campaign
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

    # below actions control signups for the mohalla clinic service that is live
    # at the community level in Punjab - one for GEMS, ANC and PNC
    # TODO - add actions below for the three different


    private

    def turn_params
      params.permit!
    end

    def exotel_params
      params.permit!
    end

    def initiate_logger
      self.logger = Logger.new("#{Rails.root}/log/punjab/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{params}")
    end

  end
end
