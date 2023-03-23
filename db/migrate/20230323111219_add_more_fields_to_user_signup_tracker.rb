class AddMoreFieldsToUserSignupTracker < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_signup_trackers, :state
    add_column :user_signup_trackers, :call_sid, :string
    add_column :user_signup_trackers, :sms_id, :string
  end
end
