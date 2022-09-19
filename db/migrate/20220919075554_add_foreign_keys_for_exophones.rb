class AddForeignKeysForExophones < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :exophones, :noora_programs, column: :program_id
    add_foreign_key :exophones, :condition_areas
    add_foreign_key :exophones, :languages

    add_foreign_key :textit_groups, :noora_programs, column: :program_id
    add_foreign_key :textit_groups, :condition_areas
    add_foreign_key :textit_groups, :languages

    add_foreign_key :textit_group_user_mappings, :textit_groups
    add_foreign_key :textit_group_user_mappings, :users

  end
end
