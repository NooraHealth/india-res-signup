# == Schema Information
#
# Table name: user_import_jobs
#
#  id              :bigint           not null, primary key
#  import_date     :datetime
#  number_of_users :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class UserImportJob < ApplicationRecord

  has_many :user_import_job_items

end
