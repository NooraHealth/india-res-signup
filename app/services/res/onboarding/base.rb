# this will be the base class for our generalized onboarding process for RES going forward.
# The steps involved are:
# 1. User is onboarded onto WA as soon as they call
# 2. If user answers further questions their properties are duly updated by us step-by-step
# 3. If not, the user is asked the relevant questions on WA, post which they are acknowledged at our end

module Res
  module Onboarding
    class Base < ApplicationService

      attr_accessor :logger, :errors, :parsed_exotel_params, :textit_group

      def initialize(logger)
        self.logger = logger
        self.errors = []
      end


      protected

      # this method will return the onboarding method of the user based
      # on their type - i.e. based on the class called
      def onboarding_method
        ""
      end

      def qr_code_identifier
        ""
      end

      def retrieve_exophone
        self.exophone = Exophone.find_by virtual_number: self.parsed_exotel_params[:exophone]
      end


      def retrieve_user_from_ivr_params(mobile_number)
        self.res_user = User.find_by(mobile_number: mobile_number)
        if self.res_user.present?
          self.logger.info("SUCCESSFULLY FOUND user in DATABASE with number #{self.res_user.mobile_number}")
        end
      end

      # this method adds a user to the relevant textit group using TextIt's APIs
      def create_user_with_relevant_group
        params = {id: self.res_user.id}
        params[:textit_group_id] = self.textit_group&.textit_id
        params[:logger] = self.logger
        # below line interacts with the API handler for TextIt and creates the user
        params[:fields] = {
          "date_joined" => (self.res_user.whatsapp_onboarding_date || DateTime.now),
          "onboarding_method" => onboarding_method,
          "qr_code_id" => qr_code_identifier,
          "language_selected" => (self.res_user.language_selected ? "1" : "0"),
          "expected_date_of_delivery" => self.res_user.expected_date_of_delivery
        }

        op = TextitRapidproApi::CreateUser.(params)
        if op.errors.present?
          self.errors = op.errors
          return false
        end
        true
      end

      # If a user is already on TextIt, the user is added to an existing group which is identified
      # from the TextitGroup class
      def add_user_to_existing_group
        params = {id: self.res_user.id, uuid: self.res_user.textit_uuid}
        params[:textit_group_id] = self.textit_group&.textit_id
        params[:logger] = self.logger
        params[:fields] = {
          "date_joined" => (self.res_user.whatsapp_onboarding_date || DateTime.now),
          "onboarding_method" => onboarding_method,
          "qr_code_id" => qr_code_identifier,
          "language_selected" => (self.res_user.language_selected ? "1" : "0"),
          "expected_date_of_delivery" => self.res_user.expected_date_of_delivery
        }

        op = TextitRapidproApi::UpdateGroup.(params)
        if op.errors.present?
          self.errors = op.errors
          return false
        end
        true
      end


      # this method extracts the mobile number of the user based on where requests are coming from
      # For ex. if it's from TextIt, it will be based on the urns attribute etc.
      def extract_mobile_number(channel, params)
        case channel
        when "textit"
          # the data is sent like so:
          # "mobile_number"=>["whatsapp:918105739684", "tel:+918105739684"]
          params["mobile_number"].each do |urn|
            if urn.include?("tel")
              return "0#{urn.chars.last(10).join}"
            end
          end
        else
          ""
        end
        ""
      end

    end
  end
end
