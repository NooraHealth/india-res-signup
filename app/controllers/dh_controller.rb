class DhController < ApplicationController

  def exotel_wa_signup
    logger = Logger.new("#{Rails.root}/log/dh_signup_exotel.log")
    logger.info("Params sent from Exotel: #{dh_params}")
    op = Res::DistrictHospitals::ExotelWaSignup.(logger, dh_params)
    if op.errors.present?
      logger.info("Operation returned error: #{op.errors.to_sentence}")
    end
    # for now return 200 no matter what
    render 'exotel_wa_signup'
  end


  def change_whatsapp_number
    logger = Logger.new("#{Rails.root}/log/dh_change_whatsapp_number.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{sdh_params}")
    op = Res::SubDistrictHospitals::ChangeWhatsappNumber.(logger, sdh_params)
    if op.errors.present?
      logger.info("Operation failed and returned error: #{op.errors.to_sentence}")
    end
    logger.info("Successfully changed user's WA number")
  end

  private

  def dh_params
    # todo - allow only certain parameters here in the future
    params.permit!
  end

end
