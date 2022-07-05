class CreateTextitGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :textit_groups do |t|
      t.string :name
      t.integer :program_id, references: "NooraProgram", foreign_key: true, index: true
      t.string :textit_id
      t.integer :condition_area_id, references: "ConditionArea", foreign_key: true, index: true
      t.string :exotel_number

      t.timestamps
    end
  end
end
