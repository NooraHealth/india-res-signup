class AddMoreFieldsToRchProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :rch_profiles, :asha_name, :string
    add_column :rch_profiles, :case_no, :integer
  end
end