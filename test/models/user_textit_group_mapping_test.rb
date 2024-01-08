# == Schema Information
#
# Table name: user_textit_group_mappings
#
#  id                    :bigint           not null, primary key
#  event_timestamp       :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  textit_group_id       :bigint           not null
#  user_event_tracker_id :bigint
#  user_id               :bigint           not null
#
# Indexes
#
#  index_user_textit_group_mappings_on_textit_group_id        (textit_group_id)
#  index_user_textit_group_mappings_on_user_event_tracker_id  (user_event_tracker_id)
#  index_user_textit_group_mappings_on_user_id                (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (textit_group_id => textit_groups.id)
#  fk_rails_...  (user_event_tracker_id => user_event_trackers.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class UserTextitGroupMappingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
