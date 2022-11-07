class CreateUserConditionAreaMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :user_condition_area_mappings do |t|
      t.references :user, foreign_key: true
      t.references :condition_area, foreign_key: true

      t.timestamps
    end
  end
end
