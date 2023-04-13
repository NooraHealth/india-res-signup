class AddCampaignSidToSignupTrackers < ActiveRecord::Migration[5.2]
  def change
    add_column :user_signup_trackers, :campaign_sid, :string
  end
end
