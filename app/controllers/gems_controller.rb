class GemsController < ApplicationController

  attr_accessor :res_user, :logger

  before_action :initiate_logger

  skip_before_action :verify_authenticity_token

  def ivr_modality_selection
    op = Res::Gems::IvrModalitySelection.(logger, gems_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully updated user's modality preferences")
  end


  def ivr_language_selection
    op = Res::Gems::IvrLanguageSelection.(logger, gems_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully updated user's language")
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


  def unsubscribe_ivr
    op = Res::Gems::UnsubscribeIvr.(logger, gems_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully selected unsubscribed from IVR services")
  end


  private

  def gems_params
    params.permit!
  end


  def initiate_logger
    self.logger = Logger.new("#{Rails.root}/log/gems/#{action_name}.log")
    self.logger.info("-------------------------------------")
    logger.info("API parameters are: #{gems_params}")
  end

end