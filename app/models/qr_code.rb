# == Schema Information
#
# Table name: qr_codes
#
#  id               :bigint           not null, primary key
#  name             :string
#  link_encoded     :string
#  state_id         :bigint
#  noora_program_id :bigint
#  text_identifier  :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class QrCode < ApplicationRecord
  belongs_to :state
  belongs_to :noora_program

  def self.id_from_text_identifier(text_identifier)
    QrCode.find_by(text_identifier: text_identifier)&.id
  end
end
