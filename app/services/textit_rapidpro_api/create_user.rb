# calls the RapidPro API to create a user with the specified group ID

module TextitRapidproApi

  class CreateUser < TextitRapidproApi::Base

    attr_accessor :textit_user, :textit_group, :params, :logger, :user

    def initialize(params)
      self.params = params
      self.errors = []
      self.logger = params[:logger]
    end

    def call
      # null conditions

      setup_connection

      retrieve_user_from_db
      if self.user.blank?
        self.errors << "User not found in database"
        return self
      end

      create_user
      self
    end

    private

    def api_method
      :post
    end

    def action_path
      "contacts.json"
    end

    def retrieve_user_from_db
      self.user = User.find_by(id: self.params[:id])
    end

    def body_params
      language_iso_code = self.user.language_preference&.iso_code
      group_id = self.params[:textit_group_id]
      custom_fields = self.params[:fields]
      {
        "groups" => [group_id],
        "language" => language_iso_code,
        "urns" => %W[tel:#{user.international_whatsapp_number} whatsapp:#{user.international_whatsapp_number[1..user.international_whatsapp_number.length]}],
        "fields" => custom_fields
      }
    end

    def create_user
      execute_api_call

      if self.response.status == 200 || self.response.status == 201
        # success response, also log it
        self.logger&.info("SUCCESSFUL creation of User on TEXTIT with number #{self.user.whatsapp_mobile_number}")
        # update the UUID of the user as well
        parsed_response = JSON.parse(self.response.body)
        uuid = parsed_response["uuid"]
        self.user.update(textit_uuid: uuid)
      elsif self.response.status == 400
        parsed_response = JSON.parse(self.response.body)
        self.logger&.info("FAILED creation of User on TEXTIT with number #{self.user.whatsapp_mobile_number} with reason: #{parsed_response}")
        self.errors << "FAILED creation of User on TEXTIT with number #{self.user.whatsapp_mobile_number} with reason: #{parsed_response}"
      elsif self.response.status == 429
        # means we have exceeded the rate limiting limit. Log the user in a separate file and deal with it soon
        rate_limiting_logger = Logger.new("#{Rails.root}/log/missed_users_from_rate_limiting.log")
        rate_limiting_logger.warn("#{user.international_whatsapp_number}")
      else
        parsed_response = JSON.parse(self.response.body) rescue {}
        self.logger&.info("ERROR on API request to TEXTIT for user with number #{self.user.whatsapp_mobile_number} with reason: #{parsed_response} and HTTP status: #{self.response.status}")
        self.errors << "ERROR on API request to TEXTIT for user with number #{self.user.whatsapp_mobile_number} with reason: #{parsed_response} and HTTP status: #{self.response.status}"
      end

    end

  end

end