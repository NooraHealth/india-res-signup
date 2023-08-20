# == Schema Information
#
# Table name: import_job_items
#
#  id                  :bigint           not null, primary key
#  api_params          :jsonb
#  error_message       :text
#  external_identifier :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  import_job_id       :bigint           not null
#  import_status_id    :bigint           not null
#  user_id             :integer
#
# Indexes
#
#  index_import_job_items_on_import_job_id     (import_job_id)
#  index_import_job_items_on_import_status_id  (import_status_id)
#  index_import_job_items_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (import_job_id => import_jobs.id)
#  fk_rails_...  (import_status_id => import_statuses.id)
#  fk_rails_...  (user_id => users.id)
#
class ImportJobItem < ApplicationRecord
  belongs_to :import_job
  belongs_to :user, optional: true, dependent: :destroy
  belongs_to :import_status


end
