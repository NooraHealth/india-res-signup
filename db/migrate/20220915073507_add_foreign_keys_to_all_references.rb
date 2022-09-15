class AddForeignKeysToAllReferences < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :state_id, :integer, foreign_key: true, index: true
    add_reference :users, :states
    add_foreign_key :users, :noora_programs, column: :program_id
    add_foreign_key :users, :condition_areas
    add_foreign_key :users, :languages, column: :language_preference_id
    add_foreign_key :users, :states
    add_foreign_key :users, :hospitals
  end
end
