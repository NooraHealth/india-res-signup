# == Schema Information
#
# Table name: user_signup_trackers
#
#  id                   :bigint           not null, primary key
#  user_id              :bigint
#  condition_area_id    :bigint
#  noora_program_id     :bigint
#  language_id          :bigint
#  active               :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  state_id             :bigint
#  call_sid             :string
#  exophone             :string
#  onboarding_method_id :bigint
#  completed            :boolean
#  sms_id               :string
#
require 'test_helper'

class UserSignupTrackerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
