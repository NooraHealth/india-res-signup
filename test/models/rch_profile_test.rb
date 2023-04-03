# == Schema Information
#
# Table name: rch_profiles
#
#  id                  :bigint           not null, primary key
#  name                :string
#  health_facility     :text
#  health_block        :text
#  health_sub_facility :text
#  village             :text
#  rch_id              :string
#  husband_name        :string
#  mother_age          :integer
#  anm_name            :text
#  anm_contact         :string
#  asha_contact        :string
#  registration_date   :datetime
#  high_risk_details   :text
#  user_id             :bigint
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  asha_name           :string
#  case_no             :integer
#  high_risk_pregnancy :boolean          default(FALSE)
#  mobile_of           :string
#  address             :string
#  med_past_illness    :string
#  rch_visit_1_date    :datetime
#  rch_visit_2_date    :datetime
#  rch_visit_3_date    :datetime
#  rch_visit_4_date    :datetime
#  rch_visit_5_date    :datetime
#  rch_visit_6_date    :datetime
#  rch_visit_7_date    :datetime
#  rch_visit_8_date    :datetime
#
require 'test_helper'

class RchProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
