class AddImportTypeToImportJobs < ActiveRecord::Migration[7.0]
  def change
    add_reference :import_jobs, :import_status
    add_column :import_jobs, :maximum_items, :integer, default: 1000

    rename_column :import_job_items, :user_import_job_id, :import_job_id
  end
end
