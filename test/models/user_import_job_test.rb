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
require "test_helper"

class UserImportJobTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
