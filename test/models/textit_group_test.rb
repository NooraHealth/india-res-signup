# == Schema Information
#
# Table name: textit_groups
#
#  id                :bigint           not null, primary key
#  name              :string
#  program_id        :integer
#  textit_id         :string
#  condition_area_id :integer
#  exotel_number     :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  language_id       :integer
#  state_id          :bigint
#
require 'test_helper'

class TextitGroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
