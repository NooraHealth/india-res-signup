class AddCallStatusToUserSignupTrackers < ActiveRecord::Migration[5.2]
  def change
    add_column :user_signup_trackers, :call_status, :string
  end
end
