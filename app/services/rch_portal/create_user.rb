# this operation adds a single user to our database. This will typically be used to
# onboard a particular user from an external source onto our database
# The endpoint is token protected and validation of the token happens
# in the controller

# This operation will also handle cases where we need to add a user to a different campaign
# if they are already signed up for our service by other means, we need to refine their campaign
# to the EDD-based campaign through textit

module RchPortal
  class CreateUser < RchPortal::Base

    attr_accessor :rch_params, :rch_user, :state_id, :onboarding_method_id

    def initialize(logger, params)
      super(logger)
      self.rch_params = params
    end


    def call
      # First check by phone number, to see if the user is already present
      # if user is already present, we update their campaign to the RCH one and
      # return a success message saying that this user has already signed up and shall
      # be added to the right campaign

      self.rch_user = User.find_by(mobile_number: "0#{self.rch_params[:mobile_number]}")

      # check if expected date of delivery is present
      edd = self.rch_params[:expected_date_of_delivery]
      if edd.blank?
        self.errors << "Expected date of delivery cannot be empty"
        return self
      end

      self.state_id = State.id_for(self.rch_params[:state_name])
      if self.state_id.blank?
        self.errors << "State cannot be blank"
        return
      end

      # if the user is already present and signed up to WA, we check for whether they're part of RCH
      # or not, and if not sign them up to the relevant campaign
      if self.rch_user.present? and self.rch_user.signed_up_to_whatsapp?

        # if the user is already present, but signed up for another program, we will silently
        # switch their campaign to the correct one in the backend if they are still pregnant
        edd = Date.parse(self.rch_params[:expected_date_of_delivery])
        if self.rch_user.program_id != NooraProgram.id_for(:rch)
          # create the RCH profile of the user first
          create_rch_profile(self.rch_user)

          # if their EDD is in the future, add them to the respective state's RCH campaign
          if edd > Date.today
            # update the user's params to RCH and add EDD, LMP etc.
            update_user(self.rch_params)

            textit_group = TextitGroup.where(condition_area_id: ConditionArea.id_for(:anc),
                                             program_id: NooraProgram.id_for(:rch),
                                             state_id: self.rch_user.state_id).first

            cf_params = {
              "date_joined" => DateTime.now,
              "expected_date_of_delivery" => self.rch_user.expected_date_of_delivery,
              "onboarding_method" => "rch_portal_direct"
            }

            # now update the user to the relevant group
            add_user_to_existing_group(self.rch_user, textit_group, cf_params)
            add_signup_tracker(self.rch_user)
            return self
          else
            # i.e. the user is already part of another campaign, but we got their data
            # after their EDD has passed. In this case we do NOTHING

            # .....Wow such empty, much wow.....
            self.errors << "User with mobile #{self.rch_user.mobile_number} part of another campaign and has passed EDD"
            return self
          end
        end


        # if we reached here, that means the user is already present and signed up for WA through RCH itself
        self.errors << "User with mobile number #{self.rch_params[:mobile_number]} already present with ID: #{self.rch_user.id} as part of #{self.rch_user&.program&.name}"
        return self
      end

      # next, look for the user by RCH ID, if user already exists throw error
      profile = RchProfile.find_by(rch_id: self.rch_params[:rch_id])
      if profile&.user&.present?
        # In this case, a user with this profile already exists and would have been
        # routed to the right campaign before this anyway, so throw error and exit

        self.errors << "User with RCH ID: #{self.rch_params[:rch_id]} already exists."
        return self
      end

      # extract onboarding method from API params
      onboarding_method = self.rch_params[:onboarding_method]&.downcase
      onboarding_method_id = OnboardingMethod.id_for(onboarding_method)

      create_user(onboarding_method_id)
      return self if self.errors.present?

      add_condition_area(self.rch_user)

      create_rch_profile(self.rch_user)

      self
    end

    private

    def create_rch_profile(user)
      rch_profile = user.build_rch_profile(rch_id: self.rch_params[:rch_id],
                                                    name: self.rch_params[:name],
                                                    health_facility: self.rch_params[:health_facility],
                                                    district: self.rch_params[:district],
                                                    health_sub_facility: self.rch_params[:health_sub_facility],
                                                    health_block: self.rch_params[:health_block],
                                                    village: self.rch_params[:village],
                                                    high_risk_pregnancy: self.rch_params[:high_risk_pregnancy],
                                                    husband_name: self.rch_params[:husband_name],
                                                    mother_age: self.rch_params[:mother_age],
                                                    anm_name: self.rch_params[:anm_name],
                                                    anm_contact: self.rch_params[:anm_contact],
                                                    asha_name: self.rch_params[:asha_name],
                                                    asha_contact: self.rch_params[:asha_contact],
                                                    registration_date: self.rch_params[:registration_date],
                                                    high_risk_details: self.rch_params[:high_risk_details],
                                                    case_no: self.rch_params[:case_no],
                                                    mobile_of: self.rch_params[:mobile_of],
                                                    address: self.rch_params[:address],
                                                    blood_group: self.rch_params[:blood_group],
                                                    med_past_illness: self.rch_params[:med_past_illness],
                                                    rch_visit_1_date: self.rch_params[:rch_visit_1_date],
                                                    rch_visit_2_date: self.rch_params[:rch_visit_2_date],
                                                    rch_visit_3_date: self.rch_params[:rch_visit_3_date],
                                                    rch_visit_4_date: self.rch_params[:rch_visit_4_date],
                                                    rch_visit_5_date: self.rch_params[:rch_visit_5_date],
                                                    rch_visit_6_date: self.rch_params[:rch_visit_6_date],
                                                    rch_visit_7_date: self.rch_params[:rch_visit_7_date],
                                                    rch_visit_8_date: self.rch_params[:rch_visit_8_date]
      )

      # unless RCH profile gets saved, do not proceed
      unless rch_profile.save
        self.errors << "RCH profile could not be created because: #{rch_profile.errors.full_messages.to_sentence}"
        return self
      end
    end


    def add_condition_area(user)
      # add condition area to the user based on the expected date of delivery
      # The criteria is always the date of importing. If the current date is greater than the EDD, the mother is marked as PNC, otherwise ANC
      if self.rch_user.expected_date_of_delivery > Date.today
        condition_area_id = ConditionArea.id_for(:anc)
      else
        condition_area_id = ConditionArea.id_for(:pnc)
      end

      # add this user to this respective condition area
      self.rch_user.add_condition_area(self.rch_user.program_id, condition_area_id)
    end

    def create_user(onboarding_method_id)
      # if the user is not found yet, create the user
      self.rch_user = User.new(mobile_number: "0#{self.rch_params[:mobile_number]}",
                               name: self.rch_params[:name],
                               program_id: NooraProgram.id_for(:rch),
                               state_id: self.state_id,
                               last_menstrual_period: self.rch_params[:last_menstrual_period],
                               expected_date_of_delivery: self.rch_params[:expected_date_of_delivery],
                               onboarding_method_id: onboarding_method_id
      )

      # unless user record gets saved, do not proceed
      unless self.rch_user.save
        self.errors << "User could not be created because: #{self.rch_user.errors.full_messages.to_sentence}"
        return self
      end
    end

    def add_signup_tracker(user)
      tracker = self.rch_user.user_event_trackers.build(
        noora_program_id: NooraProgram.id_for(:rch),
        language_id: user.language_preference_id,
        onboarding_method_id: OnboardingMethod.id_for(:rch_portal_direct),
        state_id: self.state_id,
        completed: true,
        condition_area_id: ConditionArea.id_for(:anc),
        event_timestamp: DateTime.now
      )
      unless tracker.save
        self.errors << tracker.errors.full_messages
        return false
      end
      true
    end

    def update_user(params)
      self.rch_user.update(expected_date_of_delivery: params[:expected_date_of_delivery],
                           last_menstrual_period: params[:last_menstrual_period],
                           program_id: NooraProgram.id_for(:rch),
                           onboarding_method_id: OnboardingMethod.id_for(:rch_portal_direct))
    end

  end
end
