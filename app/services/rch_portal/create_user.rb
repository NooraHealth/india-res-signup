# this operation adds a single user to our database. This will typically be used to
# onboard a particular user from an external source onto our database
# The endpoint is token protected and validation of the token happens
# in the controller

module RchPortal
  class CreateUser < RchPortal::Base

    attr_accessor :rch_params, :rch_user

    def initialize(logger, params)
      super(logger)
      self.rch_params = params
    end

    def call

      # check if the user already exists in the database
      # First check by phone number
      self.rch_user = User.find_by(mobile_number: self.rch_params[:mobile_number])
      if self.rch_user.present?
        self.errors << "User with mobile number #{self.rch_params[:mobile_number]}"
        return self
      end

      # next, look for the user by RCH ID
      profile = RchProfile.find_by(rch_id: self.rch_params[:rch_id])
      if profile&.user&.present?
        self.errors << "User with RCH ID: #{self.rch_params[:rch_id]} already exists."
        return self
      end

      state_id = self.rch_params[:state_id] || State.id_for(self.rch_params[:state_name])

      # if the user is not found yet, create the user
      self.rch_user = User.new(mobile_number: "0#{self.rch_params[:mobile_number]}",
                      program_id: NooraProgram.id_for(:rch),
                      state_id: state_id,
                      last_menstrual_period: self.rch_params[:last_menstrual_period],
                      expected_date_of_delivery: self.rch_params[:expected_date_of_delivery]
                     )

      # unless user record gets saved, do not proceed
      unless self.rch_user.save
        self.errors << "User could not be created because: #{user.errors.full_messages.to_sentence}"
        return self
      end

      # add condition area to the user based on the expected date of delivery
      # The criteria is always the date of importing. If the current date is greater than the EDD, the mother is marked as PNC, otherwise ANC
      if self.rch_user.expected_date_of_delivery > Date.today
        condition_area_id = ConditionArea.id_for(:anc)
      else
        condition_area_id = ConditionArea.id_for(:pnc)
      end

      # add this user to this respective condition area
      self.rch_user.add_condition_area(self.rch_user.program_id, condition_area_id)

      rch_profile = self.rch_user.build_rch_profile(rch_id: self.rch_params[:rch_id],
                                           name: self.rch_params[:name],
                                           health_facility: self.rch_params[:health_facility],
                                           health_block: self.rch_params[:health_block],
                                           village: self.rch_params[:village],
                                           husband_name: self.rch_params[:husband_name],
                                           mother_age: self.rch_params[:mother_age],
                                           anm_name: self.rch_params[:anm_name],
                                           anm_contact: self.rch_params[:anm_contact],
                                           # asha_name: self.rch_params[:asha_name],
                                           asha_contact: self.rch_params[:asha_contact],
                                           registration_date: self.rch_params[:registration_date],
                                           high_risk_details: self.rch_params[:high_risk_details]
                                          )

      # unless RCH profile gets saved, do not proceed
      unless rch_profile.save
        self.errors << "RCH profile could not be created because: #{rch_profile.errors.full_messages.to_sentence}"
        return self
      end

      self
    end

  end
end