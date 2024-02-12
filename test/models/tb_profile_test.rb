# == Schema Information
#
# Table name: tb_profiles
#
#  id                                      :bigint           not null, primary key
#  basis_of_diagnosis_final_interpretation :string
#  basis_of_diagnosis_test_name            :string
#  enrolment_date                          :datetime
#  facility_district                       :string
#  facility_phi                            :string
#  facility_state                          :string
#  facility_tu                             :string
#  patient_district                        :string
#  patient_state                           :string
#  patient_taluka                          :string
#  patient_tu                              :string
#  pin_code                                :string
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  user_id                                 :bigint           not null
#
# Indexes
#
#  index_tb_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class TbProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end