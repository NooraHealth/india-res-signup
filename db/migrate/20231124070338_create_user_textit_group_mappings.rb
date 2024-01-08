class CreateUserTextitGroupMappings < ActiveRecord::Migration[7.0]
  def change
    create_table :user_textit_group_mappings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :textit_group, null: false, foreign_key: true
      t.datetime :event_timestamp
      t.references :user_event_tracker, foreign_key: true

      t.timestamps
    end
  end
end
