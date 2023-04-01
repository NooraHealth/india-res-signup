# this controller will be the one that orchestrates all actions to do with RES in Andhra Pradesh
# This controller is unique in that the cloud telephony provider is Ozonetel and not Exotel
# All RES related actions as well as RCH related actions will be done here

module DistrictHospitals
  class AndhraPradeshController < ApplicationController

    def res_ivr_initialize_user

    end

    def ccp_ivr_select_condition_area

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


    private

    def turn_params
      params.permit!
    end

    def exotel_params
      params.permit!
    end

    def initiate_logger
      self.logger = Logger.new("#{Rails.root}/log/res/andhra_pradesh/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{hp_dh_params}")
    end

  end
end
