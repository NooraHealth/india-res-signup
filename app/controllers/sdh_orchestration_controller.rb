class SdhOrchestrationController < ApplicationController

  attr_accessor :logger

  before_action :initiate_logger

  # checks if the user is part of the SDH program
  # 1 - user present and has signed up for the SDH program
  # 0 - user not present or has not signed up fully for SDH
  def check_existing_user
    user = retrieve_user_from_exotel_params
    if user.present? and user.fully_signed_up_for_sdh?
      render json: {select: 1}
      logger.info("User found and fully signed up with mobile number: #{user.mobile_number}")
    else
      logger.info("User not found or not fully signed up with mobile number: #{sdh_params["CallFrom"]}")
      render json: {select: 0}
    end
  end


  # this action returns the number of weeks since signup of the user
  def weeks_since_signup
    user = retrieve_user_from_exotel_params
    if user.present? and user.fully_signed_up_for_sdh?
      age = ((Date.today - user.incoming_call_date&.to_date).to_i) rescue 1
      weeks = (age.to_f / 7 + 0.1).ceil
      render json: {select: weeks}
      logger.info("Returned number of weeks: #{weeks}")
    else
      # as in the user is not present, or the user isn't fully signed up to our IVR service
      logger.info("Returned number of weeks: Error, user not fully signed up")
      render json: {select: 0}
    end
  end


  def day_of_week
    day = Date.today.wday
    logger.info("Returned day of the week: #{day}")
    render json: {select: day}
  end


  private

  def sdh_params
    params.permit!
  end

  def retrieve_user_from_exotel_params
    parsed_exotel_params = ExotelWebhook::ParseExotelParams.(sdh_params)
    res_user = User.find_by(mobile_number: parsed_exotel_params[:user_mobile])
  end

  def initiate_logger
    self.logger = Logger.new("#{Rails.root}/log/sdh_orchestration/#{action_name}.log")
    self.logger.info("-------------------------------------")
    logger.info("API parameters are: #{sdh_params}")
  end

end
