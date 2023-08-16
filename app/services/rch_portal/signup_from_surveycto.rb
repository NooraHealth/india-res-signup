# this class will onboard a user onto WhatsApp based on parameters sent from the SurveyCTO application
# This operation is currently only in use for SCANU mothers and families in Bangladesh
#
# Incoming parameters:
# {
#   "expected_date_of_delivery": <timestamp>,
#   "mobile_numbers": ["XXXXXXXXXX", "XXXXXXXXXX"] // format of number will be 10 digit number WITHOUT 880
#   "condition_area": "anc"
#   "program": "rch",
#   "country": "India",
#   "language": ""
#   "state": "Name of state",
#   "reference_mobile_number": "<number>" // mobile number of the original call
#   "call_id": "", # will be a unique ID for this teletraining call record
#
# }
#
# Response:
# Will be an array of objects the size of the original list of mobile numbers
# [
#   {
#     "mobile_number": <mobile number of the user>,
#     "success": <Status of onboarding of the user, can be true/false>,
#     "errors": <If the onboarding fails or if the user has already been onboarded, the errors will come here
#   },
#
#   {
#   .
#   .
#   },
# .
# .
# ]
#

module RchPortal
  class SignupFromSurveycto < RchPortal::Base

    attr_accessor :surveycto_params, :res_users, :failed_users, :textit_group, :mobile_numbers, :expected_date_of_delivery,
                  :program, :condition_area, :language, :onboarding_method_id, :call_id, :users_result, :state,
                  :reference_user, :baby_date_of_birth

    def initialize(logger, survey_cto_params)
      super(logger)
      self.surveycto_params = survey_cto_params
      self.errors = []
      self.res_users = []
      self.failed_users = []
      self.users_result = []
    end

    def call

      # parse out parameters
      # TODO - add validation here of some sort to confirm if the parameters are congruent with each other
      self.condition_area = ConditionArea.find_by_name(self.surveycto_params[:condition_area])
      self.program = NooraProgram.find_by_name(self.surveycto_params[:program])
      self.language = Language.with_code(self.surveycto_params[:language])
      self.state = State.find_by(name: self.surveycto_params[:state])
      self.mobile_numbers = self.surveycto_params[:mobile_numbers]
      self.expected_date_of_delivery = self.surveycto_params[:expected_date_of_delivery]
      self.call_id = self.surveycto_params[:call_id]
      self.baby_date_of_birth = self.surveycto_params[:baby_date_of_birth]


      # retrieve the reference user if there's a legitimate one
      self.reference_user = User.find_by mobile_number: "0#{self.surveycto_params[:reference_mobile_number]}"

      self.onboarding_method_id = OnboardingMethod.id_for(:teletraining_call)

      # create user if they don't exist already
      self.mobile_numbers.each do |mobile|
        existing_user = User.find_by mobile_number: "0#{mobile}"
        if existing_user.present?
          # if the user is already added to WhatsApp and is in ANC, add a signup tracker and move on
          if existing_user.signed_up_to_whatsapp?
            # now unless the user wants to sign on to the PNC campaign (i.e. the condition area is pnc)
            # we just acknowledge that the user has signed up and move on.
            # If the condition area is pnc, then we will add them to the PNC campaign
            if existing_user.anc?(NooraProgram.id_for(:rch)) and self.condition_area.pnc?
              self.res_users << existing_user
              next
            end

            add_signup_tracker(existing_user)
            self.users_result << {mobile_number: existing_user.mobile_number, success: true, errors: "User already signed up to WhatsApp for the ANC campaign"}
          else
            self.res_users << existing_user
          end
        else
          # if the user isn't already present
          user = create_user("0#{mobile}")
          if user.present?
            self.res_users << user
          else
            self.users_result << {mobile_number: mobile, success: false, errors: self.errors}
          end
        end
      end

      # find right textit group for mapping
      retrieve_textit_group

      if self.textit_group.blank?
        self.res_users.each do |user|
          self.users_result << {mobile_number: user.mobile_number, success: false, errors: "Textit group not found in database"}
        end

        # logic ends here and the operation can return
        return self
      end

      # now create the user on TextIt with the relevant parameters
      self.res_users.each do |user|
        op = create_user_with_relevant_group(user)
        if op.errors.present?
          # i.e. if the creation of a new user fails, try updating the user's group details
          op = add_user_to_existing_group(user)
          # if adding to group also failed, record the reason and move on
          if op.errors.present?
            self.users_result << {mobile_number: user.mobile_number, success: false, errors: op.errors}
          else
            user.update(signed_up_to_whatsapp: true, whatsapp_onboarding_date: DateTime.now)
            self.users_result << {mobile_number: user.mobile_number, success: true, textit_uuid: user.reload.textit_uuid}
          end
        else
          user.update(signed_up_to_whatsapp: true, whatsapp_onboarding_date: DateTime.now)
          self.users_result << {mobile_number: user.mobile_number, success: true, textit_uuid: user.reload.textit_uuid}
        end

      end


      # add signup tracker that records the fact that they are successfully signed up
      self.users_result.each do |user_details|
        if user_details[:errors].blank?
          user = User.find_by mobile_number: user_details[:mobile_number]
          add_signup_tracker(user)
          user.add_condition_area(self.program.id, self.condition_area.id)
        end
      end

      self
    end


    private

    def onboarding_method
      "teletraining_call"
    end

    def retrieve_textit_group

      self.textit_group = TextitGroup.where(condition_area_id: self.condition_area.id,
                                            program_id: self.program.id,
                                            state_id: self.state&.id,
                                            onboarding_method_id: OnboardingMethod.id_for(:teletraining_call)).first

    end


    def create_user(mobile_number)
      res_user = User.new(mobile_number: mobile_number,
                          expected_date_of_delivery: self.expected_date_of_delivery,
                          program_id: self.program.id,
                          language_preference_id: self.language.id,
                          reference_user_id: self.reference_user&.id,
                          baby_date_of_birth: self.baby_date_of_birth
      )

      unless res_user.save
        self.errors = res_user.errors.full_messages
        return false
      end

      res_user
    end


    def add_signup_tracker(user)
      tracker = user.user_signup_trackers.build(
        noora_program_id: self.program.id,
        onboarding_method_id: OnboardingMethod.id_for(:teletraining_call),
        call_sid: self.call_id,
        completed: true,
        condition_area_id: self.condition_area.id,
        event_timestamp: DateTime.now,
        completed_at: DateTime.now
      )
      unless tracker.save
        self.errors << tracker.errors.full_messages
        return false
      end
      true
    end


    # this method adds a user to the relevant textit group using TextIt's APIs
    def create_user_with_relevant_group(res_user)
      params = {id: res_user.id}
      params[:textit_group_id] = self.textit_group&.textit_id
      params[:logger] = self.logger
      # below line interacts with the API handler for TextIt and creates the user
      params[:fields] = {
        "date_joined" => DateTime.now,
        "onboarding_method" => onboarding_method,
        "expected_date_of_delivery" => self.expected_date_of_delivery,
        "baby_date_of_birth" => self.baby_date_of_birth
      }

      op = TextitRapidproApi::CreateUser.(params)
    end


    # If a user is already on TextIt, the user is added to an existing group which is identified
    # from the TextitGroup class
    def add_user_to_existing_group(res_user)
      params = {id: res_user.id, uuid: res_user.textit_uuid}
      params[:textit_group_id] = self.textit_group&.textit_id
      params[:logger] = self.logger
      params[:fields] = {
        "date_joined" => DateTime.now,
        "onboarding_method" => onboarding_method,
        "expected_date_of_delivery" => self.expected_date_of_delivery,
        "baby_date_of_birth" => self.baby_date_of_birth
      }

      op = TextitRapidproApi::UpdateGroup.(params)
    end

  end
end
