class ReseedNooraPrograms < ActiveRecord::Migration[7.0]
  def change
    NooraProgram.seed_data
  end
end
