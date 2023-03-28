class AddFieldsToSignupTracker < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_signup_trackers, :state
    add_column :user_signup_trackers, :call_sid, :string
    add_column :user_signup_trackers, :exophone, :string
    add_reference :user_signup_trackers, :onboarding_method
    add_column :user_signup_trackers, :completed, :boolean, default: false
    add_column :user_signup_trackers, :sms_id, :string
    add_reference :user_signup_trackers, :state
  end
end
