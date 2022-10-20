class SdhOrchestrationController < ApplicationController


  # checks if the user is part of the SDH program
  # 1 - user present and has signed up for the SDH program
  # 2 - user not present or has not signed up fully for SDH
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
    parsed_params = ExotelWebhook::ParseExotelParams.(sdh_params)
    user = User.find_by mobile_number: parsed_params[:user_mobile]
    if user.present? and user.fully_signed_up_for_sdh?
      age = ((Date.today - user.incoming_call_date&.to_date).to_i) rescue 1
      weeks = (age.to_f / 7 + 0.1).ceil
      render json: {select: weeks}
    else
      # as in the user is not present, or the user isn't fully signed up to our IVR service
      render json: {select: 0}
    end
  end

  def day_of_week
    render json: {select: Date.today.wday}
  end

  private

  def sdh_params
    params.permit!
  end

end
