class SeedLanguages < ActiveRecord::Migration[5.2]
  def change
    Language.seed_data
  end
end
