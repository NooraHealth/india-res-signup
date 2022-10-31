class SeedProgramsAndConditionAreas < ActiveRecord::Migration[5.2]
  def change
    NooraProgram.seed_data
    ConditionArea.seed_data
  end
end
