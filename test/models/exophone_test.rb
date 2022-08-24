# == Schema Information
#
# Table name: exophones
#
#  id                :bigint           not null, primary key
#  virtual_number    :string
#  language_id       :integer
#  condition_area_id :integer
#  program_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'test_helper'

class ExophoneTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
