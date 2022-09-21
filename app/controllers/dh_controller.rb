class DhController < ApplicationController

  def exotel_wa_signup
    logger = Logger.new("#{Rails.root}/log/dh_signup_exotel.log")
    logger.info("Params sent from Exotel: #{dh_params}")
    op = Res::DistrictHospitals::WaSignup.(logger, dh_params)
    if op.errors.present?
      logger.info("Operation returned error: #{op.errors.to_sentence}")
    end
    # for now return 200 no matter what
    render 'exotel_wa_signup'
  end

  private

  def dh_params
    # todo - allow only certain parameters here in the future
    params.permit!
  end

end
