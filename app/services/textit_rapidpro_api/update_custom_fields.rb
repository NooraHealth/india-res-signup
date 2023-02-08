# This operation accepts a hash map of custom fields that belong to a user in Textit and
# updates them using their contacts updation API
# The hash map should be passed as an object within params called "fields"
# eg. params = {
#               fields: {
#                        "date-joined": "12-02-2023",
#                        "expected_date_of_delivery": "12-08-2023"
#                       }
#              }

module TextitRapidproApi
  class UpdateCustomFields < TextitRapidproApi::Base

    attr_accessor :textit_user, :textit_group, :user_params, :logger, :user, :custom_fields

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

      retrieve_custom_fields_hash
      if self.custom_fields.empty?
        self.errors << "Custom fields has is empty"
        return self
      end

      update_custom_fields
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
      {
        "fields" => self.custom_fields
      }
    end

    def retrieve_custom_fields_hash
      self.custom_fields = self.user_params[:fields]
    end

    def update_custom_fields
      execute_api_call

      if self.response.status == 200 || self.response.status == 201
        # success response, also log it
        self.logger&.info("SUCCESSFUL updation of custom fields} for user with number #{self.user.mobile_number}")
      elsif self.response.status == 400
        parsed_response = JSON.parse(self.response.body)
        self.logger&.info("FAILED updation of custom fields for user with number #{self.user.mobile_number} with reason: #{parsed_response}")
        self.errors << "FAILED updation of custom fields for user with number #{self.user.mobile_number} with reason: #{parsed_response}"
      else
        parsed_response = JSON.parse(self.response.body) rescue {}
        self.logger&.info("ERROR while updation of custom fields for user with number #{self.user.mobile_number} with reason: #{parsed_response}")
        self.errors << "ERROR while updation of custom fields for user with number #{self.user.mobile_number} with reason: #{parsed_response} and HTTP status: #{self.response.status}"
      end
    end

  end
end
