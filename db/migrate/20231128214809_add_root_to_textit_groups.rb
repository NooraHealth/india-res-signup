class AddRootToTextitGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :textit_groups, :direct_entry, :boolean, default: false
  end
end
