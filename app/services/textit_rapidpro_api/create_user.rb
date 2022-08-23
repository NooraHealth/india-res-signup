# calls the RapidPro API to create a user with the specified grooup ID

module TextitRapidproApi

  class CreateUser < TextitRapidproApi::Base

    attr_accessor :textit_user, :textit_group, :user_params, :logger, :user

    def initialize(user_params)
      self.user_params = user_params
      self.errors = []
      self.logger = user_params[:logger]
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
      self.user = ExotelUser.find_by(id: self.user_params[:id])
    end

    def body_params
      language_iso_code = self.user.language_preference&.iso_code
      group_id = self.user_params[:textit_group_id]
      {
        "uuid" => self.user.textit_uuid,
        "groups" => [group_id],
        "language" => language_iso_code,
        "urns" => %W[tel:#{user.international_mobile_number} whatsapp:#{user.international_mobile_number[1..user.international_mobile_number.length]}],
        "fields" => {
          "date_joined" => (user_params[:signup_time] || DateTime.now)
        }
      }
    end

    def create_user
      execute_api_call

      if self.response.status == 200 || self.response.status == 201
        # success response, also log it
        self.logger&.info("SUCCESSFUL creation of User on TEXTIT with number #{self.user.mobile_number}")
        self.user.update(signed_up_to_whatsapp: true)
      elsif self.response.status == 400
        parsed_response = JSON.parse(self.response.body)
        self.logger&.info("FAILED creation of User on TEXTIT with number #{self.user.mobile_number} with reason: #{parsed_response}")
        self.errors << "FAILED creation of User on TEXTIT with number #{self.user.mobile_number} with reason: #{parsed_response}"
      else
        parsed_response = JSON.parse(self.response.body) rescue {}
        self.logger&.info("ERROR on API request to TEXTIT for user with number #{self.user.mobile_number} with reason: #{parsed_response} and HTTP status: #{self.response.status}")
        self.errors << "ERROR on API request to TEXTIT for user with number #{self.user.mobile_number} with reason: #{parsed_response} and HTTP status: #{self.response.status}"
      end

      self.logger&.info("\n----------------------\n")
    end



  end

end