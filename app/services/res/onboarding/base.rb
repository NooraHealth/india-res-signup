# this will be the base class for our generalized onboarding process for RES going forward.
# The steps involved are:
# 1. User is onboarded onto WA as soon as they call
# 2. If user answers further questions their properties are duly updated by us step-by-step
# 3. If not, the user is asked the relevant questions on WA, post which they are acknowledged at our end

module Res
  module Onboarding
    class Base < ApplicationService

      attr_accessor :logger, :errors, :parsed_exotel_params

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

      def qr_code_id
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
          "date_joined" => self.res_user.whatsapp_onboarding_date,
          "onboarding_method" => onboarding_method,
          "qr_code_id" => qr_code_id
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
          "date_joined" => self.res_user.whatsapp_onboarding_date,
          "onboarding_method" => onboarding_method,
          "qr_code_id" => qr_code_id
        }

        op = TextitRapidproApi::UpdateGroup.(params)
        if op.errors.present?
          self.errors = op.errors
          return false
        end
        true
      end

    end
  end
end
