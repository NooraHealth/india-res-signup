class AddCompletedAtToSignupTracjer < ActiveRecord::Migration[5.2]
  def change
    add_column :user_signup_trackers, :completed_at, :datetime
  end
end
