class AddExternalIdentifierToImportJobItem < ActiveRecord::Migration[7.0]
  def change
    add_column :import_job_items, :external_identifier, :string
  end
end
