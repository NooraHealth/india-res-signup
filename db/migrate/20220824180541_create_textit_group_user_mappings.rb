class CreateTextitGroupUserMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :textit_group_user_mappings do |t|
      t.integer :textit_group_id, references: "TextitGroup", index: true, foreign_key: true
      t.integer :user_id, references: "User", index: true, foreign_key: true
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
