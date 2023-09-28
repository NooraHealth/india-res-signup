class AddBloodGroupToRchProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :rch_profiles, :blood_group, :string
  end
end
