# == Schema Information
#
# Table name: districts
#
#  id         :bigint           not null, primary key
#  name       :string
#  state_id   :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class DistrictTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end