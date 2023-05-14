class AddCallTimestampToUserSignupTracker < ActiveRecord::Migration[5.2]
  def change
    add_column :user_signup_trackers, :event_timestamp, :datetime
  end
end
