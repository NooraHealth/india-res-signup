module RchPortal
  class Base < ApplicationService

    attr_accessor :logger, :errors, :rch_user

    def initialize(logger)
      self.logger = logger
      self.errors = []
    end

    protected

    # checks if a user is present on TextIt using their APIs - returns TRUE or FALSE
    def check_user_on_textit(rch_user)
      op = TextitRapidproApi::CheckExistingUser.(id: rch_user.id, logger: self.logger)
      op.user_found # this is a TRUE or FALSE value
    end

    # this method creates a user on TextIt with a given mobile number, language preference and
    # group ID that the user needs to be added to
    def create_user_with_relevant_group(rch_user, textit_group)
      params = {id: rch_user.id}

      params[:textit_group_id] = textit_group&.textit_id
      params[:logger] = self.logger
      params[:signup_time] = DateTime.now

      # below line interacts with the API handler for TextIt and creates the user
      op = TextitRapidproApi::CreateUser.(params)

      # once the user is added, update their custom fields
      cf_params = {id: rch_user.id}
      cf_params[:fields] = {
        "expected_date_of_delivery" => self.rch_user.expected_date_of_delivery
      }

      op = TextitRapidproApi::UpdateCustomFields.(cf_params)
    end


    # If a user is already on TextIt, the user is added to an existing group which is identified
    # from the TextitGroup class.
    # THIS SHOULD HAPPEN ONLY RARELY, because if we find that the user is already on TextIt or in our DB,
    # we should typically skip them
    def add_user_to_existing_group(rch_user, textit_group)

      params = {id: rch_user.id, uuid: rch_user.textit_uuid}
      params[:textit_group_id] = textit_group&.textit_id
      params[:logger] = self.logger
      params[:signup_time] = DateTime.now
      op = TextitRapidproApi::UpdateGroup.(params)

      # once the user is added, update their custom fields
      cf_params = {id: rch_user.id}
      cf_params[:fields] = {
        "expected_date_of_delivery" => self.rch_user.expected_date_of_delivery
      }

      op = TextitRapidproApi::UpdateCustomFields.(cf_params)
    end

  end
end
