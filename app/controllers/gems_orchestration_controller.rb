class GemsOrchestrationController < ApplicationController

  # this action retrieves the language preference of the user if they are a part of the GEMS program
  def retrieve_language
    user = retrieve_user_from_params
    render json: {select: user.language_preference_id}
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
