class AddExophoneReferenceToUserSignupTracker < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_signup_trackers, :exophone
    add_reference :user_signup_trackers, :exophone
  end
end
