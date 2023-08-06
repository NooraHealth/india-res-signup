# == Schema Information
#
# Table name: user_import_job_items
#
#  id                 :bigint           not null, primary key
#  user_import_job_id :bigint           not null
#  user_id            :bigint           not null
#  import_status_id   :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class UserImportJobItem < ApplicationRecord
  belongs_to :user_import_job
  belongs_to :user, optional: true
  belongs_to :import_status
end
