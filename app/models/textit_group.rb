# == Schema Information
#
# Table name: textit_groups
#
#  id                   :bigint           not null, primary key
#  name                 :string
#  program_id           :integer
#  textit_id            :string
#  condition_area_id    :integer
#  exotel_number        :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  language_id          :integer
#  state_id             :bigint
#  onboarding_method_id :bigint
#  qr_code_id           :bigint
#
class TextitGroup < ApplicationRecord

  validates :name, presence: true
  validates :textit_id, presence: true

  belongs_to :condition_area, optional: true
  belongs_to :program, class_name: "NooraProgram", optional: true
  belongs_to :language, optional: true
  belongs_to :state, optional: true
  belongs_to :onboarding_method, optional: true
  belongs_to :qr_code, optional: true

end
