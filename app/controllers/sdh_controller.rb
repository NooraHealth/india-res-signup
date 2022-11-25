class SdhController < ApplicationController

  attr_accessor :res_user

  def modality_selection
    logger = Logger.new("#{Rails.root}/log/sdh/modality_selection.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{sdh_params}")
    op = Res::SubDistrictHospitals::ModalitySelection.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully updated user's modality preferences")
  end


  def language_selection
    logger = Logger.new("#{Rails.root}/log/sdh/language_selection.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{sdh_params}")
    op = Res::SubDistrictHospitals::LanguageSelection.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully selected user's language")
  end


  def confirm_whatsapp_number
    logger = Logger.new("#{Rails.root}/log/sdh/whatsapp_number_confirmation.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{sdh_params}")
    op = Res::SubDistrictHospitals::ConfirmWhatsappNumber.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully confirmed user's WA number")
  end


  def change_whatsapp_number
    logger = Logger.new("#{Rails.root}/log/sdh/change_whatsapp_number.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{sdh_params}")
    op = Res::SubDistrictHospitals::ChangeWhatsappNumber.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully changed user's WA number")
  end


  def condition_area_selection
    logger = Logger.new("#{Rails.root}/log/sdh/condition_area_selection.log")
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


  def check_language_selection_complete
    self.res_user = retrieve_user_from_params
    if self.res_user&.program_id == NooraProgram.id_for(:sdh) && self.res_user.language_id.present?
      render json: {select: 1}
    else
      render json: {select: 0}
    end
  end


  def check_condition_area_selection_complete
    self.res_user = retrieve_user_from_params
    if self.res_user&.program_id == NooraProgram.id_for(:sdh) && self.res_user.condition_area_id.present?
      render json: {select: 1}
    else
      render json: {select: 0}
    end
  end


  def check_whatsapp_number_confirmation_complete
    self.res_user = retrieve_user_from_params
    if self.res_user&.program_id == NooraProgram.id_for(:sdh) && (self.res_user.whatsapp_number_confirmed && !self.res_user.signed_up_to_whatsapp)
      render json: {select: 1}
    else
      render json: {select: 0}
    end
  end

  def check_modality_selection_complete
    self.res_user = retrieve_user_from_params
    if self.res_user&.program_id == NooraProgram.id_for(:sdh) && (self.res_user.signed_up_to_ivr || self.res_user.signed_up_to_whatsapp)
      render json: {select: 1}
    else
      render json: {select: 0}
    end
  end


  def outro_message
    user = retrieve_user_from_params
    if user.signed_up_to_ivr && user.signed_up_to_whatsapp
      render json: {select: 3}
    elsif user.signed_up_to_ivr
      render json: {select: 1}
    elsif user.signed_up_to_whatsapp
      render json: {select: 2}
    end
  end
  

  private

  def sdh_params
    params.permit!
  end

  def retrieve_user_from_params
    parsed_exotel_params = ExotelWebhook::ParseExotelParams.(sdh_params)
    res_user = User.find_by(mobile_number: parsed_exotel_params[:user_mobile])
  end
end
