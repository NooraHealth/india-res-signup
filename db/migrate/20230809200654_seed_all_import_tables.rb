class SeedAllImportTables < ActiveRecord::Migration[7.0]
  def change
    ImportStatus.seed_data
    ImportType.seed_data
  end
end
