class DhController < ApplicationController

  attr_accessor :logger

  before_action :initiate_logger

  def exotel_wa_signup
    op = Res::DistrictHospitals::ExotelWaSignup.(logger, dh_params)
    if op.errors.present?
      logger.info("Operation returned error: #{op.errors.to_sentence}")
    end
    # for now return 200 no matter what
    render 'exotel_wa_signup'
  end


  # CURRENTLY NO USE CASE FOR BELOW ACTION
  # def change_whatsapp_number
  #   op = Res::SubDistrictHospitals::ChangeWhatsappNumber.(logger, sdh_params)
  #   if op.errors.present?
  #     logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
  #   end
  #   logger.info("Successfully changed user's WA number")
  # end

  private

  def dh_params
    # todo - allow only certain parameters here in the future
    params.permit!
  end

  def initiate_logger
    self.logger = Logger.new("#{Rails.root}/log/dh/#{action_name}.log")
    self.logger.info("-------------------------------------")
    logger.info("API parameters are: #{dh_params}")
  end

end
