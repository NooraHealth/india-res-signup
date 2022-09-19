class SdhController < ApplicationController

  def modality_selection
    logger = Logger.new("#{Rails.root}/log/sdh_modality_selection.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{sdh_params}")
    op = Res::SubDistrictHospitals::ModalitySelection.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully updated user's modality preferences")
  end


  def language_selection
    logger = Logger.new("#{Rails.root}/log/sdh_language_selection.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{sdh_params}")
    op = Res::SubDistrictHospitals::LanguageSelection.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully selected user's language")
  end


  def confirm_whatsapp_number
    logger = Logger.new("#{Rails.root}/log/sdh_whatsapp_number_confirmation.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{sdh_params}")
    op = Res::SubDistrictHospitals::ConfirmWhatsappNumber.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully confirmed user's WA number")
  end


  def change_whatsapp_number
    logger = Logger.new("#{Rails.root}/log/sdh_change_whatsapp_number.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{sdh_params}")
    op = Res::SubDistrictHospitals::ChangeWhatsappNumber.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully changed user's WA number")
  end


  def condition_area_selection
    logger = Logger.new("#{Rails.root}/log/sdh_condition_area_selection.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{sdh_params}")
    op = Res::SubDistrictHospitals::ConditionAreaSelection.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully selected user's condition area")
  end


  def pin_code_input

  end


  def days_to_delivery

  end


  private

  def sdh_params
    params.permit!
  end
end
