# this operation will receive job ID and the parameters that are needed for creating the
# user. Import job items will be created here along with passing it along
# to along to the create user operation for RCH
# The import job needs to be in the queued status

module RchPortal
  class BulkCreateUser < ApplicationService

    include Sidekiq::Worker

    attr_accessor :import_job, :logger

    def perform(job_id, logger_path)
      # initiate logger and create the logger file
      self.logger = Logger.new(logger_path)
      self.import_job = ImportJob.find_by(id: job_id)
      self.call
    end


    # this is where the magic happens, ie users are added to the database or updated
    # based on where they were previously in the campaign
    def call
      # update the job to be in_progress
      self.import_job.update(import_status_id: ImportStatus.id_for(:in_progress))

      # now run through the items and create the users using the import items
      self.import_job.import_job_items.each do |import_item|
        # update the import_item to be in progress. Not really necessary, but helps to keep consistency
        import_item.update(import_status_id: ImportStatus.id_for(:in_progress))
        api_params = JSON.parse(import_item.api_params).with_indifferent_access
        op = RchPortal::CreateUser.(self.logger, api_params)
        if op.errors.present?
          import_item.update(import_status_id: ImportStatus.id_for(:failed), error_message: op.errors.to_sentence)
        else
          import_item.update(import_status_id: ImportStatus.id_for(:completed), user_id: op.rch_user.id)
        end
      end
    end

  end
end
