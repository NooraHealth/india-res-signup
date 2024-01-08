# this class creates the users that are sent by the government into our database
# Incoming params are as follows:

# {
#   "mobile_number": "",
#   "tb_diagnosis_date": "",
#   "tb_treatment_start_date": "",
#   "facility_state": "",
#   "facility_district": "",
#   "facility_tu": "",
#   "patient_state": "",
#   "patient_district": "",
#   "patient_tu": "",
#   "pin_code": "",
#   "basis_of_diagnosis_test_name": "",
#   "basis_of_diagnosis_final_interpretation": "",
#   "state_name": ""
# }


module TbRes
  module Onboarding
    class CreateUser < TbRes::Base

      attr_accessor :create_params, :tb_user, :tb_profile

      def initialize(logger, params)
        super(logger)
        self.create_params = params
      end


      def call

        # check if the user already exists in our database
        self.tb_user = User.find_by mobile_number: create_params[:mobile_number]

        # now extract state
        state_id = State.id_for(create_params[:state_name])

        if self.tb_user.present?
          self.errors << "User already present with ID: #{self.tb_user.id}"
          return self
        end

        self.tb_user = User.new(program_id: NooraProgram.id_for(:tb),
                                mobile_number: create_params[:mobile_number],
                                tb_diagnosis_date: create_params[:tb_diagnosis_date],
                                tb_treatment_start_date: create_params[:tb_treatment_start_date],
                                language_preference_id: Language.id_for(:kannada),
                                state_id: state_id,
                                signed_up_to_ivr: true, # this is because all users are signed up by default
                                )

        unless self.tb_user.save
          self.errors << "User could not be saved because: #{self.tb_user.errors.full_messages}"
          return self
        end

        # now create the profile of the user based on other details in the API params
        profile = self.tb_user.build_tb_profile(facility_state: create_params[:facility_state],
                                                facility_district: create_params[:facility_district],
                                                facility_tu: create_params[:facility_tu],
                                                patient_state: create_params[:patient_state],
                                                patient_district: create_params[:patient_district],
                                                patient_tu: create_params[:patient_tu],
                                                pin_code: create_params[:pin_code],
                                                basis_of_diagnosis_test_name: create_params[:basis_of_diagnosis_test_name],
                                                basis_of_diagnosis_final_interpretation: create_params[:basis_of_diagnosis_final_interpretation])

        unless profile.save
          self.tb_user.destroy # this is because the user would be left hanging without a profile
          self.errors << "Profile could not be saved because: #{profile.errors.full_messages}"
          self
        end

        self

      end

    end
  end
end