class GemsController < ApplicationController

  attr_accessor :res_user

  def modality_selection
    logger = Logger.new("#{Rails.root}/log/gems_modality_selection.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{gems_params}")
    op = Res::Gems::ModalitySelection.(logger, gems_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully updated user's modality preferences")
  end


  def language_selection
    logger = Logger.new("#{Rails.root}/log/gems_language_selection.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{gems_params}")
    op = Res::Gems::LanguageSelection.(logger, gems_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully selected user's language")
  end


  def confirm_whatsapp_number
    logger = Logger.new("#{Rails.root}/log/gems_whatsapp_number_confirmation.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{gems_params}")
    op = Res::Gems::ConfirmWhatsappNumber.(logger, gems_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully confirmed user's WA number")
  end


  def change_whatsapp_number
    logger = Logger.new("#{Rails.root}/log/gems_change_whatsapp_number.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{gems_params}")
    op = Res::Gems::ChangeWhatsappNumber.(logger, gems_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully changed user's WA number")
  end


  def condition_area_selection
    logger = Logger.new("#{Rails.root}/log/gems_condition_area_selection.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{gems_params}")
    op = Res::Gems::ConditionAreaSelection.(logger, gems_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully selected user's condition area")
  end


  def outro_message
    user = retrieve_user_from_params
    if user.signed_up_to_ivr
      render json: {select: 1}
    elsif user.signed_up_to_whatsapp
      render json: {select: 2}
    end
  end


  # checks if the user is part of the GEMS program
  # 1 - user present and has signed up for the GEMS program
  # 0 - user not present, and is signing up for the first time
  def check_existing_user
    parsed_params = ExotelWebhook::ParseExotelParams.(sdh_params)
    user = User.find_by mobile_number: parsed_params[:user_mobile], program_id: NooraProgram.id_for(:gems)
    if user.present?
      render json: {select: 1}
    else
      render json: {select: 0}
    end
  end


  # this method checks if the user has signed up fully or not for the GEMS program
  def fully_signed_up?
    # TODO
  end


  private

  def gems_params
    params.permit!
  end

  def retrieve_user_from_params
    parsed_exotel_params = ExotelWebhook::ParseExotelParams.(gems_params)
    res_user = User.find_by(mobile_number: parsed_exotel_params[:user_mobile])
  end

end