class GemsOrchestrationController < ApplicationController

  # this action retrieves the language preference of the user if they are a part of the GEMS program
  def retrieve_language
    user = retrieve_user_from_params
    render json: {select: user.language_preference_id}
  end

  # this action returns the user's condition area based on their choices in the IVR/WA nudges
  # 1 - neutral flow
  # 2 - Hypertension
  # 3 - Diabetes
  # 4 - Both Diabetes and Hypertension
  def retrieve_condition_area
    user = retrieve_user_from_params
    case user.condition_area_id

    end
  end

  def number_of_days_since_signup
    user = retrieve_user_from_params
    no_of_days = (Date.today - user.incoming_call_date.to_date).to_i
    render json: {select: no_of_days}
  end

  private

  def gems_params
    params.permit!
  end

  def retrieve_user_from_params
    parsed_exotel_params = ExotelWebhook::ParseExotelParams.(gems_params)
    res_user = User.find_by(mobile_number: parsed_exotel_params[:user_mobile])
  end
end
