class ChangeUserSignupTrackersToUserEventTypes < ActiveRecord::Migration[7.0]
  def change
    rename_table :user_signup_trackers, :user_event_trackers
  end
end
