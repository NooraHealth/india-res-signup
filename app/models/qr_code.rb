# == Schema Information
#
# Table name: qr_codes
#
#  id           :bigint           not null, primary key
#  name         :string
#  link_encoded :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class QrCode < ApplicationRecord
end
