# == Schema Information
#
# Table name: user_condition_area_mappings
#
#  id                :bigint           not null, primary key
#  user_id           :bigint
#  condition_area_id :bigint
#  noora_program_id  :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  active            :boolean          default(TRUE)
#
require 'test_helper'

class UserConditionAreaMappingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
