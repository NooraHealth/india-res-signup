class SeedConditionAreasAndPrograms < ActiveRecord::Migration[5.2]
  def change
    ConditionArea.seed_data
    NooraProgram.seed_data
  end
end
