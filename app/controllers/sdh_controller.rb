class SdhController < ApplicationController

  def modality_selection
    logger = Logger.new("#{Rails.root}/log/sdh_modality_selection.log")
    logger.info("Exotel parameters are: #{sdh_params}")
    op = Res::SubDistrictHospitals::ModalitySelection.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
  end


  def language_selection
    logger = Logger.new("#{Rails.root}/log/sdh_language_selection.log")
    logger.info("Exotel parameters are: #{sdh_params}")
    op = Res::SubDistrictHospitals::LanguageSelection.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
  end


  def pin_code_input

  end


  def days_to_delivery

  end


  def confirm_whatsapp_number
    logger = Logger.new("#{Rails.root}/log/sdh_whatsapp_number_confirmation.log")
    logger.info("Exotel parameters are: #{sdh_params}")
    op = Res::SubDistrictHospitals::ConfirmWhatsappNumber.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
  end


  def change_whatsapp_number
    logger = Logger.new("#{Rails.root}/log/sdh_change_whatsapp_number.log")
    logger.info("Exotel parameters are: #{sdh_params}")
    op = Res::SubDistrictHospitals::ChangeWhatsappNumber.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
  end


  def condition_area_selection
    logger = Logger.new("#{Rails.root}/log/sdh_condition_area_selection.log")
    logger.info("Exotel parameters are: #{sdh_params}")
    op = Res::SubDistrictHospitals::ConditionAreaSelection.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
  end


  private

  def sdh_params
    params.permit!
  end
end
