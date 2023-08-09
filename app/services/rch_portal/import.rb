# this operation will accept user records in bulk and add them to a background task
# to create the users one by one in the database.
# This service will create an object of type UserImportList which will contain the status
# of importing of each user, along with the params posted for that user

module RchPortal
  class Import < RchPortal::Base

    attr_accessor :records, :result, :raw_params, :results

    def initialize(logger, params)
      super(logger)
      self.raw_params = params
      self.records = params[:records]
    end

    def call
      # first create the import job based on the information we know
      number_of_users = self.records.count
      import_job = ImportJob.new(import_date: DateTime.now,
                                 number_of_records: number_of_users,
                                 import_status_id: ImportStatus.id_for(:queued),
                                 import_type_id: ImportType.id_for(:user)).save

      # now create the bulk import items as well for each element in self.records
      params = []
      self.records.each do |record|
        params << {import_job_id: import_job.id, import_status_id: ImportStatus.id_for(:queued), api_params: record, external_identifier: record[:mobile_number]}
      end

      self.results = ImportJobItem.insert_all!(params, returning: %w( id external_identifier), record_timestamps: true)

      # now call the bulk import class asynchronously
      logger_path = "#{Rails.root}/log/rch/bulk_import_users.log"
      RchPortal::BulkCreateUser.perform_async(import_job.id, self.records, logger_path)

    end
  end
end
