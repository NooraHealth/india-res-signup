# this class will update the database with the right condition area for the user based
# on what is sent in the request. This is a generalized class, and any service that offers
# a webhook for us to update stuff can call this endpoint to update our database with the
# changes
# Parameters:
# {
#   "mobile_number": "",
#   "condition_area": "",
#   "program": "",
#   "onboarding_method": "",
#   "language_code": ""
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
        # first look for the condition area id sent in the params
        self.condition_area_id = ConditionArea.id_for(self.update_params[:condition_area])
        if self.condition_area_id.blank?
          self.errors << "Condition area not sent for user with mobile #{self.update_params[:mobile_number]}"
          return self
        end

        # now retrieve the program_id from params
        self.program_id = NooraProgram.id_for(self.update_params[:program])
        if self.program_id.blank?
          self.errors << "Program not found for user with mobile #{self.update_params[:mobile_number]}"
          return self
        end

        # also retrieve onboarding method
        self.onboarding_method_id = OnboardingMethod.id_for(self.update_params[:onboarding_method])
        self.language_id = Language.with_code(self.update_params[:language_code])

        # retrieve the user from the database. Ideally the user should exist at this point in time
        # If they don't throw an error and exit
        self.res_user = User.find_by mobile_number: self.update_params[:mobile_number]
        if self.res_user.blank?
          self.errors << "Could not find RES user with mobile number: #{self.update_params[:mobile_number]}"
          return self
        end

        # add condition area mapping to the user
        self.res_user.add_condition_area(self.res_user.program_id, self.condition_area_id)

        # find the signup tracker associated with this user and update completed to true
        tracker = self.res_user.user_signup_trackers.where(noora_program_id: self.res_user.program_id,
                                                 state_id: self.res_user.state_id,
                                                 language_id: self.language_id,
                                                 onboarding_method_id: self.onboarding_method_id,
                                                 completed: false).first
        tracker&.update(completed: true)

        self
      end


    end
  end
end
