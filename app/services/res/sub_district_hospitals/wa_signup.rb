# this class will sign the user up to WA using TextIt API Handlers
# Typically, in the SDH project, at this time the user has given consent and has chosen their language of preference
# Once the condition area has been chosen, this operation will add the user to each respective campaign

module Res
  module SubDistrictHospitals
    class WaSignup < Res::SubDistrictHospitals::Base

      attr_accessor :exotel_params, :parsed_exotel_params, :res_user,
                    :textit_group

      def initialize(logger, exotel_params)
        super(logger)
        self.exotel_params = exotel_params
      end


      def call

        # parse exotel params to get a simple hash with details like
        self.parsed_exotel_params = ExotelWebhook::ParseExotelParams.(self.exotel_params)

        # retrieve user from the database
        retrieve_user
        if self.res_user.blank?
          self.errors = "User not found in DB"
          return self
        end

        # extract the right textit group to add the user
        retrieve_textit_group
        return self if self.errors.present?

        # check if the user already exists on Textit.
        # If they do - return true, and add them to the relevant group
        # else = return false and create a new user who belongs to the right group
        if check_user_on_textit
          # user already exists on TextIt
          add_user_to_existing_group
        else
          # create user with the relevant group
          create_user_with_relevant_group
        end

      end


      private

      def retrieve_user
        self.res_user = User.find_by(mobile_number: self.parsed_exotel_params[:user_mobile])
        if self.res_user.present?
          self.logger.info("SUCCESSFULLY FOUND user in DATABASE with number #{self.res_user.mobile_number}")
        end
      end

      def retrieve_textit_group
        condition_area_id = self.res_user.condition_area_id
        program_id = self.res_user.program_id
        language_id = self.res_user.language_preference_id
        self.textit_group = TextitGroup.where(condition_area_id: condition_area_id,
                                              program_id: program_id,
                                              language_id: language_id).first

        if self.textit_group.blank?
          self.errors << "Textit group not found for user with number: #{self.res_user.mobile_number}"
        end
      end

      # checks if a user is present on TextIt using their APIs
      def check_user_on_textit
        op = TextitRapidproApi::CheckExistingUser.(id: self.res_user.id, logger: self.logger)
        op.user_found
      end


      # this method creates a user on TextIt with a given mobile number, language preference and
      # group ID that the user needs to be added to
      def create_user_with_relevant_group
        params = {id: self.res_user.id}

        params[:textit_group_id] = self.textit_group&.textit_id
        params[:logger] = self.logger
        # below line interacts with the API handler for TextIt and creates the user
        op = TextitRapidproApi::CreateUser.(params)
      end


      # If a user is already on TextIt, the user is added to an existing group which is identified
      # from the TextitGroup class
      def add_user_to_existing_group

        params = {id: self.res_user.id, uuid: self.res_user.textit_uuid}
        params[:textit_group_id] = self.textit_group&.textit_id
        params[:logger] = self.logger
        op = TextitRapidproApi::UpdateGroup.(params)
      end

    end
  end
end
