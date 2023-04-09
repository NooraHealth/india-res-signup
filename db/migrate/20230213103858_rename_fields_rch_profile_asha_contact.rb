class RenameFieldsRchProfileAshaContact < ActiveRecord::Migration[5.2]
  def change
    rename_column :rch_profiles, :asha_mobile, :asha_contact
  end
end
