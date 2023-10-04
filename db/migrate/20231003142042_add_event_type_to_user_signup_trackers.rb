class AddEventTypeToUserSignupTrackers < ActiveRecord::Migration[7.0]
  def change
    EventType.seed_data

    add_reference :user_signup_trackers, :event_type, foreign_key: true
  end
end
