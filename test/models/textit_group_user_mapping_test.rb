# == Schema Information
#
# Table name: textit_group_user_mappings
#
#  id              :bigint           not null, primary key
#  textit_group_id :integer
#  user_id         :integer
#  active          :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'test_helper'

class TextitGroupUserMappingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
