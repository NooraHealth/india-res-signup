# == Schema Information
#
# Table name: qr_codes
#
#  id                :bigint           not null, primary key
#  name              :string
#  link_encoded      :string
#  state_id          :bigint
#  noora_program_id  :bigint
#  text_identifier   :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  condition_area_id :bigint
#  text_encoded      :string
#
require 'test_helper'

class QrCodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
