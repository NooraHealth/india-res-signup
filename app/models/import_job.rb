# == Schema Information
#
# Table name: import_jobs
#
#  id                :bigint           not null, primary key
#  import_date       :datetime
#  maximum_items     :integer          default(1000)
#  number_of_records :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  import_status_id  :bigint
#  import_type_id    :bigint
#
# Indexes
#
#  index_import_jobs_on_import_status_id  (import_status_id)
#  index_import_jobs_on_import_type_id    (import_type_id)
#
class ImportJob < ApplicationRecord

  has_many :import_job_items

  belongs_to :import_type
  belongs_to :import_status

end
