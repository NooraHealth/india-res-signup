# this controller will have all generic methods for specific data
# about a particular user

class UsersController < ApplicationController

  attr_accessor :logger

  before_action :initiate_logger

  skip_forgery_protection

  # this endpoint will be used to update the language of a particular user
  # The parameters to be accepted are:
  # Parameters:
  # {
  #   "mobile_number": "",
  #   "language_code": "",
  #   "channel": "" # textit, turn etc.
  # }
  def update_language
    op = Res::Common::UpdateLanguage.(logger, textit_params)
    if op.errors.present?
      logger.warn("Language update failed with the errors: #{op.errors.to_sentence}")
      render json: {errors: op.errors}
    else
      render json: {}
    end
  end


  # this action will return the language of the user based
  # on what was stored in the backend of the signup service
  def retrieve_language

  end

  # this endpoint acknowledges the change in condition area of a user
  # This typically happens through TextIt wherein a user selects their
  # condition area and is moved to the appropriate campaign based on that
  def acknowledge_condition_area_change

  end

  private

  def textit_params
    params.permit!
  end

  def initiate_logger
    self.logger = Logger.new("#{Rails.root}/log/res/users/#{action_name}.log")
    self.logger.info("-------------------------------------")
    logger.info("API parameters are: #{textit_params}")
  end
end
