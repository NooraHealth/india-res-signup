class SeedNooraPrograms2 < ActiveRecord::Migration[5.2]
  def change
    NooraProgram.seed_data
  end
end
