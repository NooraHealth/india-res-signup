module TextitRapidproApi
  class UpdateLanguage < TextitRapidproApi::Base

    attr_accessor :textit_user, :textit_group, :user_params, :message_logger, :user, :logger

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

      update_user
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
      language_iso_code = self.user.reload.language_preference&.iso_code
      {
        "language" => language_iso_code
      }
    end

    def update_user
      execute_api_call

      if self.response.status == 200 || self.response.status == 201
        # success response, also log it
        self.logger&.info("SUCCESSFUL updation of user language to #{self.user.reload.language_preference&.iso_code} for user with number #{self.user.mobile_number}")
        self.user.update(signed_up_to_whatsapp: true)
      elsif self.response.status == 400
        parsed_response = JSON.parse(self.response.body)
        self.logger&.info("FAILED updation of user language to #{self.user.reload.language_preference&.iso_code} for user with number #{self.user.mobile_number} with reason: #{parsed_response}")
        self.errors << "FAILED updation of language on TEXTIT for user with number #{self.user.mobile_number} with reason: #{parsed_response}"
      else
        parsed_response = JSON.parse(self.response.body) rescue {}
        self.logger&.info("ERROR while updation of user language to #{self.user.reload.language_preference&.iso_code} for user with number #{self.user.mobile_number} with reason: #{parsed_response}")
        self.errors << "ERROR while updation of language for user with number #{self.user.mobile_number} with reason: #{parsed_response} and HTTP status: #{self.response.status}"
      end
    end

  end
end