# this class updates details of the user from the sheets where we're storing details
# Attributes that are already present are not changed

module RchPortal
  class UpdateRchProfile < RchPortal::Base

    attr_accessor :rch_user, :update_params

    def initialize(logger, params)
      super(logger)
      self.update_params = params
    end

    def call

      # first find the user with the mobile number
      self.rch_user = User.find_by(mobile_number: "0#{self.update_params[:mobile_number]}")

      if self.rch_user.blank?
        self.errors << "User not found with mobile number #{self.update_params[:mobile_number]}"
        return self
      end

      state_id = State.id_for(self.update_params[:state_name])
      if self.rch_user.state_id != state_id
        self.errors << "User is not part of the state: #{self.update_params[:state_name]}"
        return self
      end


      rch_profile = self.rch_user.rch_profile
      rch_profile_params = {}
      rch_profile_params[:name] = self.update_params[:name] if rch_profile.name.blank?
      rch_profile[:health_facility] = self.update_params[:health_facility] if rch_profile.health_facility.blank?
      rch_profile[:health_block] = self.update_params[:health_block] if rch_profile.health_block.blank?
      rch_profile[:health_sub_facility] = self.update_params[:health_sub_facility] if rch_profile.health_sub_facility.blank?
      rch_profile[:village] = self.update_params[:village] if rch_profile.village.blank?
      rch_profile[:husband_name] = self.update_params[:husband_name] if rch_profile.husband_name.blank?
      rch_profile[:mother_age] = self.update_params[:mother_age] if rch_profile.mother_age.blank?
      rch_profile[:anm_name] = self.update_params[:anm_name] if rch_profile.anm_name.blank?
      rch_profile[:anm_contact] = self.update_params[:anm_contact] if rch_profile.anm_contact.blank?
      rch_profile[:asha_contact] = self.update_params[:asha_contact] if rch_profile.asha_contact.blank?
      rch_profile[:asha_name] = self.update_params[:asha_name] if rch_profile.asha_name.blank?
      rch_profile[:registration_date] = self.update_params[:registration_date] if rch_profile.registration_date.blank?
      rch_profile[:high_risk_details] = self.update_params[:high_risk_details] if rch_profile.high_risk_details.blank?
      rch_profile[:case_no] = self.update_params[:case_no] if rch_profile.case_no.blank?
      rch_profile[:mobile_of] = self.update_params[:mobile_of] if rch_profile.mobile_of.blank?
      rch_profile[:address] = self.update_params[:address] if rch_profile.address.blank?
      rch_profile[:rch_visit_1_date] = self.update_params[:rch_visit_1_date] if rch_profile.rch_visit_1_date.blank?
      rch_profile[:rch_visit_2_date] = self.update_params[:rch_visit_2_date] if rch_profile.rch_visit_2_date.blank?
      rch_profile[:rch_visit_3_date] = self.update_params[:rch_visit_3_date] if rch_profile.rch_visit_3_date.blank?
      rch_profile[:rch_visit_4_date] = self.update_params[:rch_visit_4_date] if rch_profile.rch_visit_4_date.blank?
      rch_profile[:rch_visit_5_date] = self.update_params[:rch_visit_5_date] if rch_profile.rch_visit_5_date.blank?
      rch_profile[:rch_visit_6_date] = self.update_params[:rch_visit_6_date] if rch_profile.rch_visit_6_date.blank?
      rch_profile[:rch_visit_7_date] = self.update_params[:rch_visit_7_date] if rch_profile.rch_visit_7_date.blank?
      rch_profile[:rch_visit_8_date] = self.update_params[:rch_visit_8_date] if rch_profile.rch_visit_8_date.blank?

      unless rch_profile.update(rch_profile_params)
        self.errors << rch_profile.errors.full_messages
        return self
      end

      self
    end
  end
end
