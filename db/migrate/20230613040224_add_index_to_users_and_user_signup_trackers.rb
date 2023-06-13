class AddIndexToUsersAndUserSignupTrackers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :mobile_number
    add_index :user_signup_trackers, :call_sid
  end
end
