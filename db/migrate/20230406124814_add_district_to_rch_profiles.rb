class AddDistrictToRchProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :rch_profiles, :district, :string
  end
end
