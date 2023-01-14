class GemsOrchestrationController < ApplicationController

  attr_accessor :logger

  before_action :initiate_logger

  # this action retrieves the language preference of the user if they are a part of the GEMS program
  def retrieve_language
    user = retrieve_user_from_exotel_params
    render json: {select: user.language_preference_id}
  end


  # this action returns the user's condition area based on their choices in the IVR/WA nudges
  # 1 - neutral flow
  # 2 - Hypertension
  # 3 - Diabetes
  # 4 - Both Diabetes and Hypertension
  def retrieve_condition_area
    user = retrieve_user_from_exotel_params
    condition_areas = user.condition_areas
    if condition_areas.pluck(:id).include?(ConditionArea.id_for(:diabetes))
      if condition_areas.pluck(:id).include?(ConditionArea.id_for(:hypertension))
        return_value = 4
      else
        return_value = 3
      end
    elsif condition_areas.include?(ConditionArea.id_for(:hypertension))
      return_value = 2
    else
      return_value = 1
    end
    render json: {select: return_value}
  end


  # this action returns the number of days from the date the user called
  # i.e. incoming_call_date
  def number_of_days_since_signup
    user = retrieve_user_from_exotel_params
    no_of_days = (Date.today - user.incoming_call_date.to_date).to_i
    render json: {select: no_of_days}
  end


  private

  def gems_params
    params.permit!
  end

  def retrieve_user_from_exotel_params
    parsed_exotel_params = ExotelWebhook::ParseExotelParams.(gems_params)
    res_user = User.find_by(mobile_number: parsed_exotel_params[:user_mobile])
  end

  def initiate_logger
    self.logger = Logger.new("#{Rails.root}/log/gems_orchestration/#{action_name}.log")
    self.logger.info("-------------------------------------")
    logger.info("API parameters are: #{gems_params}")
  end
end
