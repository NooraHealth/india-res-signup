class CreateExophones < ActiveRecord::Migration[5.2]
  def change
    create_table :exophones do |t|
      t.string :virtual_number
      t.integer :language_id, references: "Language", foreign_key: true, index: true
      t.integer :condition_area_id, references: "ConditionArea", foreign_key: true, index: true
      t.integer :program_id, references: "NooraProgram", foreign_key: true, index: true

      t.timestamps
    end
  end
end
