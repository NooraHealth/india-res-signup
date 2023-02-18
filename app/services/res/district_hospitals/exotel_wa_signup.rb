# This is the single class responsible for all WA based signups in District Hospitals
# The flow will be as follows:
# 1. Identify exophone from which call is coming
# 2. Identify Condition Area, Language, and Program that the exophone corresponds to (in the case of DH, this works because every combination of those three has a unique number)
# 3. Identify the TextitGroup that the user needs to belong to based on the above three criteria
# 4. Update the user's preferences and keep track of the new group that they are subscribing to
# 5. Use TextIt's API to create / update user with

module Res
  module DistrictHospitals

    class ExotelWaSignup < Res::DistrictHospitals::Base

      attr_accessor :exotel_params, :parsed_exotel_params, :res_user,
                    :exophone, :textit_group, :language_id, :program_id, :condition_area_id,
                    :errors

      def initialize(logger, params)
        super(logger)
        self.exotel_params = params
        self.errors = []
      end

      def call

        # parse exotel params to get a simple hash with details like
        self.parsed_exotel_params = ExotelWebhook::ParseExotelParams.(self.exotel_params)

        # retrieve the exophone that the user has called
        retrieve_exophone
        return self if self.errors.present?

        # extract details of the user from parsed exotel parameters
        retrieve_user
        if self.res_user.blank?
          # if user doesn't exist, create the user in DB
          create_res_user
        else
          # update user's preferences - i.e. their language of choice, condition area etc. based on the latest call
          update_user_parameters
        end
        return self if self.errors.present?

        # retrieve the relevant TextIt group to add the user to
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

      protected

      # this method creates a user that belongs to the RES service based on the parameters that were
      # sent to the user
      def create_res_user
        self.res_user = User.new(
          language_preference_id: self.exophone.language_id,
          condition_area_id: self.exophone.condition_area_id,
          program_id: self.exophone.program_id,
          state_id: self.exophone.state_id,
          incoming_call_date: DateTime.now,
          mobile_number: self.parsed_exotel_params[:user_mobile]
        )

        unless self.res_user.save
          self.errors << self.res_user.errors.full_messages
          return
        end

        # add this user to the relevant condition area
        self.res_user.add_condition_area(self.exophone.program_id, self.exophone.condition_area_id)
      end

      # this function updates the user's preferences based on the signup instruction
      def update_user_parameters
        unless self.res_user.update(
          language_preference_id: self.exophone.language_id,
          condition_area_id: self.exophone.condition_area_id,
          program_id: self.exophone.program_id,
          state_id: self.exophone.state_id,
          incoming_call_date: DateTime.now
        )
          self.errors << self.res_user.errors.full_messages
          return
        end

        # also update the condition area of the user within the same program
        self.res_user.update_condition_area(self.exophone.program_id, self.exophone.condition_area_id)
      end

      def add_user_to_existing_group
        # add a mapping between user and textit groups so that we can keep track of it here
        # In this case, there will be a trail of all the textit groups that the user was a part of
        # self.res_user.textit_group_exotel_user_mappings.update_all(active: false)
        # self.res_user.textit_group_exotel_user_mappings.create(textit_group_id: self.textit_group&.id, active: true)

        # adding user to the relevant group on Textit using the UpdateGroup class
        params = {id: self.res_user.id, uuid: self.res_user.textit_uuid}
        params[:textit_group_id] = self.textit_group&.textit_id
        params[:logger] = self.logger
        params[:fields] = {
          "date_joined" => self.res_user.incoming_call_date
        }

        # params[:signup_time] = self.res_user.incoming_call_date
        op = TextitRapidproApi::UpdateGroup.(params)
      end

      def create_user_with_relevant_group
        # create user's TextitGroupMapping to reflect their latest preference
        # self.res_user.textit_group_exotel_user_mappings.create(textit_group_id: self.textit_group&.id, active: true)

        # create a user on TextIt with the right group parameters
        params = {id: self.res_user.id}
        params[:textit_group_id] = self.textit_group&.textit_id
        params[:logger] = self.logger
        params[:fields] = {
          "date_joined" => self.res_user.incoming_call_date
        }

        # params[:signup_time] = self.res_user.incoming_call_date
        op = TextitRapidproApi::CreateUser.(params)
      end

      # def check_user_on_textit
      #   op = TextitRapidproApi::CheckExistingUser.(id: self.res_user.id, logger: self.logger)
      #   op.user_found
      # end

    end
  end
end