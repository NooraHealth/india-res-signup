# This operation updates the group of a user and also resets the reference date
# so that date-joined is also updated to the latest value in the database

module TextitRapidproApi
  class UpdateGroup < TextitRapidproApi::Base

    attr_accessor :textit_user, :textit_group, :user_params, :logger, :user

    def initialize(user_params)
      self.user_params = user_params
      self.errors = []
      self.logger = user_params[:logger]
    end

    def call
      setup_connection

      retrieve_user_from_db
      if self.user.blank?
        self.errors << "User not found in database"
        return self
      end

      if self.user.textit_uuid.blank?
        # first check on the Textit database if the user exists. The below operation also updates the user's textit_uuid in the database
        op = TextitRapidproApi::CheckExistingUser.(id: self.user.id)

        if self.user.reload.textit_uuid.blank?
          self.errors << "User does not exist in TextIt"
          return self
        end
      end

      update_group
      self
    end

    private

    def api_method
      :post
    end

    def action_path
      "contacts.json?uuid=#{self.user.textit_uuid}"
    end

    def retrieve_user_from_db
      self.user = User.find_by(id: self.user_params[:id])
    end

    def body_params
      # TODO - ideally only the group attributes must be getting updated

      language_iso_code = self.user.reload.language_preference&.iso_code
      group_id = self.user_params[:textit_group_id]
      custom_fields = self.user_params[:fields]
      {
        "groups" => [group_id],
        "language" => language_iso_code,
        "urns" => %W[tel:#{user.international_whatsapp_number} whatsapp:#{user.international_whatsapp_number[1..user.international_whatsapp_number.length]}],
        "fields" => custom_fields
      }
    end

    def update_group
      execute_api_call

      if self.response.status == 200 || self.response.status == 201
        # success response, also log it
        self.logger&.info("SUCCESSFUL updation of user group to #{self.user_params[:textit_group_id]} for user with number #{self.user.mobile_number}")
        self.user.update(signed_up_to_whatsapp: true)
      elsif self.response.status == 400
        parsed_response = JSON.parse(self.response.body)
        self.logger&.info("FAILED updation of user group to #{self.user_params[:textit_group_id]} for user with number #{self.user.mobile_number} with reason: #{parsed_response}")
        self.errors << "FAILED updation of group on TEXTIT for user with number #{self.user.mobile_number} with reason: #{parsed_response}"
      elsif self.response.status == 429
        # means we have exceeded the rate limiting limit. Log the user in a separate file and deal with it soon
        rate_limiting_logger = Logger.new("#{Rails.root}/log/missed_users_from_rate_limiting.log")
        rate_limiting_logger.warn("#{user.international_whatsapp_number}")
        self.errors << "API Request throttled. User #{user.international_whatsapp_number} will be parked for later"
      else
        parsed_response = JSON.parse(self.response.body) rescue {}
        self.logger&.info("ERROR while updation of user group to #{self.user_params[:textit_group_id]} for user with number #{self.user.mobile_number} with reason: #{parsed_response}")
        self.errors << "ERROR while updation of group for user with number #{self.user.mobile_number} with reason: #{parsed_response} and HTTP status: #{self.response.status}"
      end
    end
  end
end