class SdhOrchestrationController < ApplicationController


  # checks if the user is part of the SDH program
  # 1 - user present and has signed up for the SDH program
  # 0 - user not present or has not signed up fully for SDH
  def check_existing_user
    parsed_params = ExotelWebhook::ParseExotelParams.(sdh_params)
    user = User.find_by mobile_number: parsed_params[:user_mobile]
    if user.present? and user.fully_signed_up_for_sdh?
      render json: {select: 1}
    else
      render json: {select: 0}
    end
  end


  # this action returns the number of weeks since signup of the user
  def weeks_since_signup
    logger = Logger.new("#{Rails.root}/log/sdh/weeks_since_signup.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{sdh_params}")

    parsed_params = ExotelWebhook::ParseExotelParams.(sdh_params)
    user = User.find_by mobile_number: parsed_params[:user_mobile]
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
    logger = Logger.new("#{Rails.root}/log/sdh/day_of_week.log")
    logger.info("-------------------------------------")
    logger.info("Exotel parameters are: #{sdh_params}")
    day = Date.today.wday
    logger.info("Returned day of the week: #{day}")
    render json: {select: day}
  end

  private

  def sdh_params
    params.permit!
  end

end
