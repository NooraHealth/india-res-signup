class AddFieldsToRchProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :rch_profiles, :mobile_of, :string
    add_column :rch_profiles, :address, :string
    add_column :rch_profiles, :med_past_illness, :string
    add_column :rch_profiles, :rch_visit_1_date, :datetime
    add_column :rch_profiles, :rch_visit_2_date, :datetime
    add_column :rch_profiles, :rch_visit_3_date, :datetime
    add_column :rch_profiles, :rch_visit_4_date, :datetime
    add_column :rch_profiles, :rch_visit_5_date, :datetime
    add_column :rch_profiles, :rch_visit_6_date, :datetime
    add_column :rch_profiles, :rch_visit_7_date, :datetime
    add_column :rch_profiles, :rch_visit_8_date, :datetime
  end
end
