class GemsController < ApplicationController

  attr_accessor :res_user, :logger

  before_action :initiate_logger

  skip_before_action :verify_authenticity_token

  def modality_selection
    op = Res::Gems::ModalitySelection.(logger, gems_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully updated user's modality preferences")
  end


  def language_selection
    op = Res::Gems::LanguageSelection.(logger, gems_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully selected user's language")
  end


  def confirm_whatsapp_number
    op = Res::Gems::ConfirmWhatsappNumber.(logger, gems_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully confirmed user's WA number")
  end


  def change_whatsapp_number
    op = Res::Gems::ChangeWhatsappNumber.(logger, gems_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully changed user's WA number")
  end


  # when the user selects their condition area through an IVR Call
  def ivr_condition_area_selection
    op = Res::Gems::IvrConditionAreaSelection.(logger, gems_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully selected user's condition area")
  end


  # when the user selects their condition area through WA message
  def whatsapp_condition_area_selection
    op = Res::Gems::WhatsappConditionAreaSelection.(logger, gems_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully selected user's condition area")
  end



  def outro_message
    user = retrieve_user_from_params
    if user.signed_up_to_ivr
      render json: {select: 1}
      logger.info("Option returned is: 1")
    elsif user.signed_up_to_whatsapp
      render json: {select: 2}
      logger.info("Option returned is: 2")
    end
  end


  # checks if the user is part of the GEMS program
  # 1 - user present and has fully signed up for the GEMS program
  # 0 - user not present, and is signing up for the first time, or hasn't signed up completely
  def check_existing_user
    user = retrieve_user_from_params
    if user.present? && user.fully_signed_up_to_gems?
      render json: {select: 1}
      logger.info("Option returned is: 1")
    else
      render json: {select: 0}
      logger.info("Option returned is: 2")
    end
  end


  private

  def gems_params
    params.permit!
  end

  def retrieve_user_from_params
    parsed_exotel_params = ExotelWebhook::ParseExotelParams.(gems_params)
    res_user = User.find_by(mobile_number: parsed_exotel_params[:user_mobile])
  end

  def initiate_logger
    self.logger = Logger.new("#{Rails.root}/log/gems/#{action_name}.log")
    self.logger.info("-------------------------------------")
    logger.info("API parameters are: #{gems_params}")
  end

end