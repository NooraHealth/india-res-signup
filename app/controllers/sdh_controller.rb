class SdhController < ApplicationController

  attr_accessor :res_user

  before_action :initiate_logger

  skip_before_action :verify_authenticity_token

  def modality_selection
    op = Res::SubDistrictHospitals::ModalitySelection.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully updated user's modality preferences")
  end


  def language_selection
    op = Res::SubDistrictHospitals::LanguageSelection.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully selected user's language")
  end


  def confirm_whatsapp_number
    op = Res::SubDistrictHospitals::ConfirmWhatsappNumber.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully confirmed user's WA number")
  end


  def change_whatsapp_number
    op = Res::SubDistrictHospitals::ChangeWhatsappNumber.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully changed user's WA number")
  end


  def ivr_condition_area_selection
    op = Res::SubDistrictHospitals::IvrConditionAreaSelection.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully selected user's condition area")
  end

  def ivr_pin_code_input

  end


  def whatsapp_pin_code_input

  end


  def ivr_days_to_delivery

  end

  def whatsapp_days_to_delivery

  end


  def check_language_selection_complete
    self.res_user = retrieve_user_from_params
    if self.res_user&.program_id == NooraProgram.id_for(:sdh) && self.res_user.language_id.present?
      logger.info("Language selection complete and API returned: 1")
      render json: {select: 1}
    else
      logger.info("Language selection incomplete and API returned: 2")
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


  # this action returns the right modality of the user based on their selection in the previous menus
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

  def initiate_logger
    self.logger = Logger.new("#{Rails.root}/log/sdh/#{action_name}.log")
    self.logger.info("-------------------------------------")
    logger.info("API parameters are: #{sdh_params}")
  end
end
