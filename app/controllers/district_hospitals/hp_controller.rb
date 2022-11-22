class DistrictHospitals::HpController < ApplicationController

  # this action first creates the user with all the initial conditions that we assume for
  # a user from HP
  # Condition Area - PNC
  # Program: MCH
  # State - Himachal Pradesh
  # Language - Hindi
  def initialize_user
    logger = Logger.new("#{Rails.root}/log/dh/hp/initialize_user.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{hp_dh_params}")
    op = Res::DistrictHospitals::Hp::InitializeUser.(logger, hp_dh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully initialized user in DB")
  end


  def wa_signup
    logger = Logger.new("#{Rails.root}/log/dh/hp/wa_signup.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{hp_dh_params}")
    op = Res::DistrictHospitals::ExotelWaSignup.(logger, hp_dh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully signed up user to WhatsApp")
  end


  def change_whatsapp_number
    logger = Logger.new("#{Rails.root}/log/dh/hp/change_whatsapp_number.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{hp_dh_params}")
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

end
