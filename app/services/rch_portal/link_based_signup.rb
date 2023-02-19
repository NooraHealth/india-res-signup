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

    attr_accessor :turn_params, :rch_user

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

      # if the user is already onboarded onto WA, ignore the request to onboard them again
      if self.rch_user.signed_up_to_whatsapp
        self.errors << "User with number #{self.turn_params[:mobile_number]} is already signed up to WhatsApp"
        return self
      end

      # Update the onboarding method for this user based on where the link is coming from
      onboarding_method_id = OnboardingMethod.id_for(self.turn_params[:onboarding_method])
      self.rch_user.update(onboarding_method_id: onboarding_method_id)

      # first extract the relevant params to be used for determining user's campaign
      language_id = Language.with_code(self.turn_params[:language_code])&.id
      condition_area_id = ConditionArea.id_for(self.turn_params[:condition_area])
      state_id = State.id_for(self.turn_params[:state_name])
      program_id = NooraProgram.id_for(self.turn_params[:program_name])

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
      cf_params = {id: self.rch_user.id}
      cf_params[:fields] = {
        "date_joined" => DateTime.now,
        "expected_date_of_delivery" => self.rch_user.expected_date_of_delivery,
        "onboarding_method" => self.rch_user.onboarding_method&.name
      }

      # now add user to the respective group on TextIt
      # If the user is already on textit, don't do anything. Because this user is already onboarded onto
      # some other program
      if check_user_on_textit(self.rch_user)
        result = add_user_to_existing_group(self.rch_user, textit_group, cf_params)
      else
        result = create_user_with_relevant_group(self.rch_user, textit_group, cf_params)
      end

      # if there is an issue signing up the user onto, WA don't update the flag for that user
      if result.errors.present?
        self.errors += result.errors
        return self
      end

      self.rch_user.update(signed_up_to_whatsapp: true) # indicating that the user has successfully signed up to WhatsApp

      self
    end
  end
end
