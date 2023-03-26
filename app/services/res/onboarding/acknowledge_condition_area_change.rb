# this class will update the database with the right condition area for the user based
# on what is sent in the request. This is a generalized class, and any service that offers
# a webhook for us to update stuff can call this endpoint to update our database with the
# changes. The "channel" attribute gives us where the request is coming from
# Parameters:
# {
#   "mobile_number": "",
#   "condition_area": "",
#   "program_name": "",
#   "onboarding_method": "",
#   "language_code": "",
#   "channel": "" # textit, turn etc.
# }

module Res
  module Onboarding
    class AcknowledgeConditionAreaChange < Res::Onboarding::Base

      attr_accessor :update_params, :res_user, :condition_area_id, :program_id, :onboarding_method_id,
                    :language_id

      def initialize(logger, update_params)
        super(logger)
        self.update_params = update_params
      end


      def call
        # based on the channel, extract the mobile number
        channel = self.update_params[:channel]

        # first extract the mobile number of the user
        mobile_number = extract_mobile_number(channel, update_params)
        if mobile_number.blank?
          self.errors << "User not found with mobile number: #{mobile_number}"
          return self
        end

        # first look for the condition area id sent in the params
        self.condition_area_id = ConditionArea.id_for(self.update_params[:condition_area])
        if self.condition_area_id.blank?
          self.errors << "Condition area not sent for user with mobile #{mobile_number}"
          return self
        end

        # now retrieve the program_id from params
        self.program_id = NooraProgram.id_for(self.update_params[:program_name])
        if self.program_id.blank?
          self.errors << "Program not found for user with mobile #{mobile_number}"
          return self
        end

        # also retrieve onboarding method
        self.onboarding_method_id = OnboardingMethod.id_for(self.update_params[:onboarding_method])

        # retrieve the user from the database. Ideally the user should exist at this point in time
        # If they don't throw an error and exit
        self.res_user = User.find_by mobile_number: mobile_number
        if self.res_user.blank?
          self.errors << "Could not find RES user with mobile number: #{mobile_number}"
          return self
        end

        # add condition area mapping to the user
        self.res_user.add_condition_area(self.res_user.program_id, self.condition_area_id)

        # update the signup tracker
        update_signup_tracker

        self
      end

      private

      def update_signup_tracker
        tracker = self.res_user.user_signup_trackers.where(noora_program_id: self.res_user.program_id,
                                                           state_id: self.res_user.state_id,
                                                           onboarding_method_id: self.onboarding_method_id,
                                                           completed: false).first

        if tracker.blank?
          self.errors << "Tracker not found for user with mobile: #{self.res_user.mobile_number}"
          return self
        end

        unless tracker.update(completed: true, condition_area_id: self.condition_area_id, completed_at: DateTime.now)
          self.errors << tracker.errors.full_messages
          return false
        end
        true
      end


    end
  end
end
