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
#  error_message      :text
#  api_params         :jsonb
#
require "test_helper"

class UserImportJobItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
