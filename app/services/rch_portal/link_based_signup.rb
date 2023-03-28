# this class will add the user onto WA using a joining link sent via a link
# This operation will essentially identify the state, language and condition area for a user
# based on what is sent in params, and add user to the respective campaign on TextIt
# Expected Params:
# - language code
# - state name
# - state id
# - condition area
# - program name
# - onboarding_method
# This operation also accepts the onboarding method which can be SMS or QR Code for now

module RchPortal
  class LinkBasedSignup < RchPortal::Base

    attr_accessor :turn_params, :rch_user, :state_id, :language_id, :condition_area_id, :program_id,
                  :onboarding_method_id

    def initialize(logger, params)
      super(logger)
      self.turn_params = params
    end

    def call

      # look for the user in our database
      user_mobile = self.turn_params[:mobile_number]
      self.rch_user = User.find_by mobile_number: user_mobile

      # if the user does not exist, return an error for now because we are only interested in users
      # who are already added in our backend
      if self.rch_user.blank?
        self.errors << "User with number #{self.turn_params[:mobile_number]} not found in database"
        return self
      end

      # # if the user is already onboarded onto WA and is part of the RCH program, ignore the request to onboard them again
      # if self.rch_user.signed_up_to_whatsapp && self.rch_user.program_id == NooraProgram.id_for(:rch)
      #   self.errors << "User with number #{self.turn_params[:mobile_number]} is already signed up to WhatsApp"
      #   return self
      # end

      # if the user is not part of the RCH program, then also raise an error message and log it
      if self.rch_user.program_id != NooraProgram.id_for(:rch)
        self.errors << "User with mobile number #{self.rch_user.mobile_number} is not part of the RCH program"
        return self
      end

      # Update the onboarding method for this user based on where the link is coming from
      self.onboarding_method_id = OnboardingMethod.id_for(self.turn_params[:onboarding_method])
      self.rch_user.update(onboarding_method_id: onboarding_method_id)

      # first extract the relevant params to be used for determining user's campaign
      self.language_id = Language.with_code(self.turn_params[:language_code])&.id
      self.condition_area_id = ConditionArea.id_for(self.turn_params[:condition_area])
      self.state_id = State.id_for(self.turn_params[:state_name])
      self.program_id = NooraProgram.id_for(self.turn_params[:program_name])

      # update the user's language preference to the one reflected in the API
      self.rch_user.update(language_preference_id: language_id)

      # find the textit group associated with the above characteristics
      textit_group = TextitGroup.find_by(condition_area_id: condition_area_id,
                                         state_id: state_id,
                                         program_id: program_id)

      # if there's non textit group, add an error to the log file
      if textit_group.blank?
        self.errors << "Textit group not found for user with number: #{self.rch_user&.mobile_number}"
        return self
      end

      # add the custom fields as a hash so that it can be added to a user's profile
      cf_params = {
        "date_joined" => DateTime.now,
        "expected_date_of_delivery" => self.rch_user.expected_date_of_delivery,
        "onboarding_method" => self.rch_user.onboarding_method&.name
      }

      unless create_user_with_relevant_group(self.rch_user, textit_group, cf_params)
        # resetting errors because we don't need them to carry over for the whole rest of the request
        self.errors = []
        add_user_to_existing_group(self.rch_user, textit_group, cf_params)
      end

      # if there are issues with signing on the user don't update the user as signed up
      return self if self.errors.present?

      self.rch_user.update(signed_up_to_whatsapp: true, whatsapp_onboarding_date: DateTime.now) # indicating that the user has successfully signed up to WhatsApp

      add_signup_tracker

      self
    end

    private

    def add_signup_tracker
      tracker = self.rch_user.user_signup_trackers.build(
        noora_program_id: self.program_id,
        language_id: self.language_id,
        onboarding_method_id: self.onboarding_method_id,
        state_id: self.state_id,
        completed: true
      )
      unless tracker.save
        self.errors << tracker.errors.full_messages
        return false
      end
      true
    end

  end
end
