# this controller will have all generic methods for specific data
# about a particular user

class UsersController < ApplicationController

  attr_accessor :logger

  before_action :initiate_logger

  skip_forgery_protection

  # this endpoint will be used to update the language of a particular user
  # It will also acknowledge the fact that a user's language has changed when they do this
  # on Textit
  # The parameters to be accepted are:
  # Parameters:
  # {
  #   "mobile_number": ["whatsapp:XXXX", "tel:+91XXXX"]
  #   "language_code": "",
  #   "channel": "" # textit, turn etc.
  # }
  def update_language
    op = Res::Common::UpdateLanguage.(logger, language_params)
    if op.errors.present?
      logger.warn("Language update failed with the errors: #{op.errors.to_sentence}")
      render json: {errors: op.errors}
    else
      render json: {}
    end
  end


  # this action will return the language of the user based
  # on what was stored in the backend of the signup service
  # Expected Params:
  # {
  #  "mobile_number": "0XXXXXX"
  # }
  # Most likely use case is for Turn to retrieve the user's language
  def retrieve_language
    user = User.find_by mobile_number: params[:mobile_number]
    if user.blank?
      render status: 404, json: {errors: ["User not found with mobile number: #{params[:mobile_number]}"]}
    else
      render status: 200, json: {language: user.language_preference}
    end
  end

  # this action will update the textit group trail in the backend
  # based on the parameters received from any platform
  def update_textit_group
    op = Res::Common::UpdateTextitGroup.(logger, textit_params)
    if op.errors.present?
      logger.warn("Textit group update failed with the errors: #{op.errors.to_sentence}")
      render json: {errors: op.errors}
    else
      render json: {success: true}
    end
  end


  private

  def language_params
    params.permit(:mobile_number)
  end

  def textit_params
    params.permit!
  end

  def initiate_logger
    self.logger = Logger.new("#{Rails.root}/log/res/users/#{action_name}.log")
    self.logger.info("-------------------------------------")
    logger.info("API parameters are: #{textit_params}")
  end
end
