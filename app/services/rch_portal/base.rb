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
      params[:signup_time] = rch_user.incoming_call_date
      # below line interacts with the API handler for TextIt and creates the user
      op = TextitRapidproApi::CreateUser.(params)
    end


    # If a user is already on TextIt, the user is added to an existing group which is identified
    # from the TextitGroup class
    def add_user_to_existing_group(rch_user, textit_group)

      params = {id: rch_user.id, uuid: rch_user.textit_uuid}
      params[:textit_group_id] = textit_group&.textit_id
      params[:logger] = self.logger
      params[:signup_time] = rch_user.incoming_call_date
      op = TextitRapidproApi::UpdateGroup.(params)
    end

  end
end
