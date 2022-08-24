class WhatsappController < ApplicationController

  skip_before_action :verify_authenticity_token

  def dh_signup
    op = Res::DistrictHospitals::WaSignup.(exotel_params)
    logger = Logger.new("#{Rails.root}/log/dh_signup_exotel.log")
    if op.errors.present?
      logger.info("Operation returned error: #{op.errors.to_sentence}")
    end
    # for now return 200 no matter what
    render 'dh_signup'
  end

  private

  def exotel_params
    # todo - allow only certain parameters here in the future
    params.permit!
  end
end
