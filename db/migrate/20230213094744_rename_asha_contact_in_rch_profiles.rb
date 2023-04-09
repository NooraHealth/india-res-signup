class RenameAshaContactInRchProfiles < ActiveRecord::Migration[5.2]
  def change
    remove_column :rch_profiles, :asha_contact, :string
  end
end
