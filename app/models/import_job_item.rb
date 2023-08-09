# == Schema Information
#
# Table name: import_job_items
#
#  id                  :bigint           not null, primary key
#  import_job_id       :bigint           not null
#  user_id             :integer
#  import_status_id    :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  error_message       :text
#  api_params          :jsonb
#  external_identifier :string
#
class ImportJobItem < ApplicationRecord
  belongs_to :import_job
  belongs_to :user, optional: true
  belongs_to :import_status


end
