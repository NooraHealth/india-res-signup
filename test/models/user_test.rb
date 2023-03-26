# == Schema Information
#
# Table name: users
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  mobile_number             :string
#  baby_date_of_birth        :datetime
#  date_of_discharge         :datetime
#  incoming_call_date        :datetime
#  program_id                :integer
#  condition_area_id         :integer
#  language_preference_id    :integer
#  language_selected         :boolean          default(FALSE)
#  signed_up_to_whatsapp     :boolean          default(FALSE)
#  signed_up_to_ivr          :boolean          default(FALSE)
#  textit_uuid               :string
#  whatsapp_id               :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  hospital_id               :integer
#  whatsapp_mobile_number    :string
#  state_id                  :integer
#  states_id                 :bigint
#  whatsapp_number_confirmed :boolean          default(FALSE)
#  ivr_unsubscribe_date      :datetime
#  whatsapp_unsubscribe_date :datetime
#  last_menstrual_period     :datetime
#  expected_date_of_delivery :datetime
#  onboarding_method_id      :bigint
#  whatsapp_onboarding_date  :datetime
#  onboarding_attempts       :integer          default(0)
#  qr_scan_date              :datetime
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
