class AddHighRiskToRchProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :rch_profiles, :high_risk_pregnancy, :boolean, default: false
  end
end
