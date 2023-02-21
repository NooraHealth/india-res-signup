# this operation checks if a particular user is already present at
# TextIt's end, and if they are, which groups they're a part of
# The expected parameters are:
# {
#   id: <DB ID of the user>
# }

module TextitRapidproApi
  class CheckExistingUser < TextitRapidproApi::Base

    attr_accessor :params, :user, :errors, :user_details, :parsed_response,
                  :logger, :user_found

    def initialize(params)
      self.params = params
      self.errors = []
      self.logger = params[:logger]
    end


    def call

      retrieve_user_from_db
      if self.user.blank?
        self.errors << "User not found"
        return self
      end
      setup_connection

      execute_api_call

      parse_response
      return self if self.errors.present?

      check_for_existing_user
      self
    end

    private

    def api_method
      :get
    end

    def action_path
      "contacts.json"
    end

    def body_params
      # number = "tel:+91#{self.user.mobile_number[1..self.user.mobile_number.length]}"
      whatsapp_number = "whatsapp:91#{self.user.whatsapp_mobile_number[1..self.user.whatsapp_mobile_number.length]}"
      {
        urn: whatsapp_number
      }
    end

    def retrieve_user_from_db
      self.user = User.find_by(id: self.params[:id])
    end

    def parse_response
      if self.response.status == 200 || self.response.status == 201
        self.parsed_response = JSON.parse(self.response.body) rescue {}
      elsif self.response.status == 429
        # means we have exceeded the rate limiting limit. Log the user in a separate file and deal with it soon
        rate_limiting_logger = Logger.new("#{Rails.root}/log/missed_users_from_rate_limiting.log")
        rate_limiting_logger.warn("#{user.international_whatsapp_number} -- from program #{user.program&.name}")
        self.errors << "API Request throttled. User #{user.international_whatsapp_number} from program #{user.program&.name} will be parked for later"
      else
        self.parsed_response = {}
        self.errors << "API request returned error: #{self.response.status}"
      end
    end

    def check_for_existing_user
      number = "+91#{self.user.mobile_number[1..self.user.mobile_number.length]}"
      whatsapp_number = "91#{self.user.mobile_number[1..self.user.mobile_number.length]}"
      contacts = self.parse_response["results"]
      if contacts.present?
        # we know that the user already exists
        urns = contacts.first["urns"]
        uuid = contacts.first["uuid"]
        if urns.include?("tel:#{number}") || urns.include?("whatsapp:#{whatsapp_number}")
        # if urns.first == "tel:#{number}" || urns.last ==
          # log that the user was found
          logger&.info("Found URNs: #{urns}")
          logger&.info("User successfully found on TextIt with number #{self.user.mobile_number} and has UUID: #{uuid}")
          self.user.update(textit_uuid: uuid)
          self.user_found = true
        end
      else
        logger&.info("User DOES NOT exist on TextIt with number: #{self.user.mobile_number}")
      end
    end

  end
end