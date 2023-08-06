
# this controller handles all actions that are involved in the SNCU UNICEF IVR flow:
# 1. Age in weeks of the baby
# 2. Language preference of the user
# 3. checking if the user is an existing one or not
# ... and so on

# This endpoint also handles users signing up up for WA by calling our SNCU number in AP and Karnataka

module ResOnboarding
  class UnicefSncuOrchestrationController < ApplicationController

    attr_accessor :parsed_exotel_params

    before_action :initiate_logger

    def retrieve_language_preference
      user = retrieve_user_from_params
      logger.info("Returned language preference: #{Language.find_by(id: user.language_preference_id)}")
      if user.present? && user.language_selected and user.language_preference_id.present?
        logger.info("User found and has selected language with ID: #{user.language_preference_id}")
        render json: { select: user.language_preference_id }
      else
        logger.info("User not found or has not selected language")
        render json: {select: 0}
      end
    end


    # checks whether a user has already signed up or not for the SNCU program
    # The way we determine if a user has been signed up formally or not is checking
    # if they have a date of birth of their baby. If they do, then we consider them "formally signed up"
    def check_existing_user
      user = retrieve_user_from_params
      if user.baby_date_of_birth.present? && user.hospital_id.present?
        logger.info("User found and has been onboarded formally")
        render json: {select: 1}
      else
        logger.info("User has not been onboarded formally")
        render json: {select: 0}
      end
    end


    def baby_age_in_weeks
      user = retrieve_user_from_params
      if user.present?
        age = ((Date.today - user.baby_date_of_birth&.to_date).to_i) rescue 1
        weeks = (age.to_f / 7 + 0.1).ceil
        render json: {select: weeks}
        logger.info("Returned number of weeks: #{weeks}")
      else
        # as in the user is not present, or the user isn't fully signed up to our IVR service
        logger.info("Error, user with mobile number #{unicef_sncu_params["From"]} not found")
        render json: {select: 0}
      end
    end


    def day_of_week
      day = Date.today.wday
      logger.info("Returned day of the week: #{day}")
      render json: {select: day}
    end


    def update_language_preference
      user = retrieve_user_from_params
      language_id = params[:language_id]
      user&.update(language_preference_id: language_id)
      render json: {}
    end

    # endpoint that onboards a user onto the SNCU WA program
    def wa_signup
      op = Res::DistrictHospitals::ExotelWaSignup.(logger, exotel_params)
      if op.errors.present?
        logger.info("Operation returned error: #{op.errors.to_sentence}")
        render json: {success: false, errors: op.errors.to_sentence}
        return
      end
      # for now return 200 if the user is successfully onboarded
      render 'dh_signup'
    end


    private

    def unicef_sncu_params
      params.permit!
    end

    def retrieve_user_from_params
      parsed_exotel_params = ExotelWebhook::ParseExotelParams.(unicef_sncu_params)
      res_user = User.find_by(mobile_number: parsed_exotel_params[:user_mobile])
    end

    def initiate_logger
      self.logger = Logger.new("#{Rails.root}/log/unicef_sncu/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{unicef_sncu_params}")
    end

  end
end
