class FixReferencesInImportJobs < ActiveRecord::Migration[7.0]
  def change
    # remove_column :import_jobs, :import_statuses_id
    # remove_column :import_jobs, :import_types_id
    #
    # add_reference :import_jobs, :import_status
    # add_reference :import_jobs, :import_type
  end
end