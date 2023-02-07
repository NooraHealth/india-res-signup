# this class will add the user onto WA using a joining link sent via SMS
# This operation will essentially identify the state, language and condition area for a user
# based on what is sent in params, and add user to the respective campaign on TextIt
# Expected Params:
# - language code
# - state name
# - state id
# - condition area
# - program

module RchPortal
  class SmsSignup < RchPortal::Base

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
        self.errors << "User not found in database"
        return self
      end

      # if the user is already onboarded onto WA, ignore the request to onboard them again
      if self.rch_user.signed_up_to_whatsapp
        self.errors << "User is already signed up to WhatsApp"
        return self
      end

      # first extract the relevant params to be used for determining user's campaign
      language_id = Language.with_code(self.turn_params[:language_code])&.id
      condition_area_id = ConditionArea.id_for(self.turn_params[:condition_area])
      state_id = State.id_for(self.turn_params[:state_name])
      program_id = State.id_for(self.turn_params[:program_id])


      # find the textit group associated with the above characteristics
      textit_group = TextitGroup.find_by(language_id: language_id,
                                         condition_area_id: condition_area_id,
                                         state_id: state_id,
                                         program_id: program_id)


      # if there's non textit group, add an error to the log file
      if textit_group.blank?
        self.errors << "Textit group not found for user with number: #{self.rch_user&.mobile_number}"
        return self
      end


      # now add user to the respective group on TextIt
      # If the user is already on textit, don't do anything. Because this user is already onboarded onto
      # some other program
      if check_user_on_textit(self.rch_user)
        self.errors << "User is already present on TextIt, and is part of these groups: []"
        return self
      else
        result = create_user_with_relevant_group(self.rch_user, textit_group)
        if result.errors.present?
          self.errors += result.errors
          return self
        end
        self.rch_user.update(signed_up_to_whatsapp: true) # indicating that the user has successfully signed up to WhatsApp
      end

      self
    end
  end
end
