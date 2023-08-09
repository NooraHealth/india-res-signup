# == Schema Information
#
# Table name: import_jobs
#
#  id                :bigint           not null, primary key
#  import_date       :datetime
#  number_of_records :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  maximum_items     :integer          default(1000)
#  import_status_id  :bigint
#  import_type_id    :bigint
#
class ImportJob < ApplicationRecord

  has_many :import_job_items

  belongs_to :import_type
  belongs_to :import_status

end
