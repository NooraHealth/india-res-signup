class AddEventTypeToUserEventTrackers < ActiveRecord::Migration[7.0]
  def change
    UserEventType.seed_data
    default = UserEventType.first
    add_reference :user_event_trackers, :user_event_type, default: default.id, null: false, foreign_key: true
  end
end
