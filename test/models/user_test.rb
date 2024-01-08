# == Schema Information
#
# Table name: users
#
#  id                         :bigint           not null, primary key
#  baby_date_of_birth         :datetime
#  date_of_discharge          :datetime
#  expected_date_of_delivery  :datetime
#  incoming_call_date         :datetime
#  ivr_unsubscribe_date       :datetime
#  language_selected          :boolean          default(FALSE)
#  last_menstrual_period      :datetime
#  mobile_number              :string
#  name                       :string
#  onboarding_attempts        :integer          default(0)
#  present_on_wa              :boolean          default(FALSE)
#  qr_scan_date               :datetime
#  registered_on_whatsapp     :boolean          default(TRUE)
#  signed_up_to_ivr           :boolean          default(FALSE)
#  signed_up_to_whatsapp      :boolean          default(FALSE)
#  tb_diagnosis_date          :datetime
#  tb_treatment_start_date    :datetime
#  textit_uuid                :string
#  whatsapp_mobile_number     :string
#  whatsapp_number_confirmed  :boolean          default(FALSE)
#  whatsapp_onboarding_date   :datetime
#  whatsapp_unsubscribe_date  :datetime
#  whatsapp_unsubscribed_date :datetime
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  condition_area_id          :integer
#  hospital_id                :integer
#  language_preference_id     :integer
#  onboarding_method_id       :bigint
#  program_id                 :integer
#  reference_user_id          :integer
#  state_id                   :integer
#  states_id                  :bigint
#  whatsapp_id                :string
#
# Indexes
#
#  index_users_on_condition_area_id       (condition_area_id)
#  index_users_on_language_preference_id  (language_preference_id)
#  index_users_on_mobile_number           (mobile_number)
#  index_users_on_onboarding_method_id    (onboarding_method_id)
#  index_users_on_program_id              (program_id)
#  index_users_on_states_id               (states_id)
#
# Foreign Keys
#
#  fk_rails_...  (condition_area_id => condition_areas.id)
#  fk_rails_...  (hospital_id => hospitals.id)
#  fk_rails_...  (language_preference_id => languages.id)
#  fk_rails_...  (onboarding_method_id => onboarding_methods.id)
#  fk_rails_...  (program_id => noora_programs.id)
#  fk_rails_...  (state_id => states.id)
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
