class AddMoreProgramsAndConditionAreasForCommunityProgram < ActiveRecord::Migration[7.0]
  def change
    NooraProgram.seed_data
    ConditionArea.seed_data
  end
end
