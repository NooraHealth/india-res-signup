class AddPlatformToUserSignupTracker < ActiveRecord::Migration[5.2]
  def change
    add_column :user_signup_trackers, :platform, :string
  end
end
