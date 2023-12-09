# == Schema Information
#
# Table name: exophones
#
#  id                :bigint           not null, primary key
#  virtual_number    :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  condition_area_id :integer
#  language_id       :integer
#  program_id        :integer
#  state_id          :bigint
#
# Indexes
#
#  index_exophones_on_condition_area_id  (condition_area_id)
#  index_exophones_on_language_id        (language_id)
#  index_exophones_on_program_id         (program_id)
#  index_exophones_on_state_id           (state_id)
#
# Foreign Keys
#
#  fk_rails_...  (condition_area_id => condition_areas.id)
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (program_id => noora_programs.id)
#
class Exophone < ApplicationRecord

  validates :virtual_number, uniqueness: true

  belongs_to :language, optional: true
  belongs_to :condition_area, optional: true
  belongs_to :program, class_name: "NooraProgram", optional: true
  belongs_to :state, optional: true

  def self.ransackable_attributes(auth_object = nil)
    # all the attributes of the model come here
    ["id", "virtual_number", "state_id", "language_id", "condition_area_id", "program_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["state", "language", "condition_area", "program"]
  end

end
