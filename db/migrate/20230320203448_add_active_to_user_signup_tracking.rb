class AddActiveToUserSignupTracking < ActiveRecord::Migration[5.2]
  def change
    add_column :user_condition_area_mappings, :active, :boolean, default: true
  end
end
