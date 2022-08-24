class AddLanguageToTextitGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :textit_groups, :language_id, :integer, references: "Language", foreign_key: true, index: true
  end
end
