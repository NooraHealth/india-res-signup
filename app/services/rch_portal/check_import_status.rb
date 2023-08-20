# This operation returns the status of each job item id. It accepts an array of job item ids
# and returns an array as the response for the N number of item ids in the request
# Request params:
# {
#   "job_item_ids": [
#                     23, 54, 65, 23, 63, 12
#                   ]
# }
#

module RchPortal
  class CheckImportStatus < RchPortal::Base

    attr_accessor :import_job_item_ids, :import_job_items, :status_params

    def initialize(logger, status_params)
      super(logger)
      self.status_params = status_params
    end

    def call
      self.import_job_item_ids = self.status_params[:job_item_ids]

      self.import_job_items = ImportJobItem.where(id: self.import_job_item_ids)
      self
    end
  end
end
