# == Schema Information
#
# Table name: textit_groups
#
#  id                :bigint           not null, primary key
#  name              :string
#  program_id        :integer
#  textit_id         :string
#  condition_area_id :integer
#  exotel_number     :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  language_id       :integer
#
class TextitGroup < ApplicationRecord

  validates :name, presence: true
  validates :textit_id, presence: true

  belongs_to :condition_area, optional: true
  belongs_to :program, class_name: "NooraProgram", optional: true
  belongs_to :language, optional: true

end
