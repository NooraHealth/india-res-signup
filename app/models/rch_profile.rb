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
#
class RchProfile < ApplicationRecord
  belongs_to :user

  validates :rch_id, uniqueness: true
end
