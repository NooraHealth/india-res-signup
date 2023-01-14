module DistrictHospitals
  class HpController < ApplicationController

    attr_accessor :logger

    before_action :initiate_logger

    # this action first creates the user with all the initial conditions that we assume for
    # a user from HP
    # Condition Area - PNC
    # Program: MCH
    # State - Himachal Pradesh
    # Language - Hindi
    def initialize_user
      op = Res::DistrictHospitals::Hp::InitializeUser.(logger, hp_dh_params)
      if op.errors.present?
        logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
      end
      logger.info("Successfully initialized user in DB")
    end


    def wa_signup
      op = Res::DistrictHospitals::ExotelWaSignup.(logger, hp_dh_params)
      if op.errors.present?
        logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
        return
      end
      logger.info("Successfully signed up user to WhatsApp")
    end


    def change_whatsapp_number
      op = Res::DistrictHospitals::Hp::ChangeWhatsappNumber.(logger, hp_dh_params)
      if op.errors.present?
        logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
      end
      logger.info("Successfully changed user's WA number and signed them up")
    end


    private

    def hp_dh_params
      params.permit!
    end

    def initiate_logger
      self.logger = Logger.new("#{Rails.root}/log/hp/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{hp_dh_params}")
    end

  end
end
