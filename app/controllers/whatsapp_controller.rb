
##########################################
############## DEPRECATED ################
##########################################

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


  # this action will update the condition area of the user in our database
  # corresponding to actions they take on Textit
  # eg. Pressing 2 for Pre-Cardiac surgery in the Cardiac Line
  # eg. Pressing 1 for Inpatient surgery in Inpatient line
  def update_condition_area

  end

  private

  def exotel_params
    # todo - allow only certain parameters here in the future
    params.permit!
  end
end
