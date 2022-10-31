# == Schema Information
#
# Table name: condition_areas
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ConditionArea < ApplicationRecord

  include Seedable

  def self.values
    [
      :anc,
      :pnc,
      :sncu,
      :inpatient_non_surgery,
      :cardiology_pre_selection,
      :cardiology,
      :cardiology_pre_surgery,
      :cardiology_post_surgery,
      :gems_neutral,
      :diabetes,
      :hypertension
    ]
  end

  # def self.retrieve_condition_area_from_number(number)
  #   ca = ConditionAreaNumberMapping.with_exotel_number(number).first
  #   return ca&.condition_area_id
  # end
end
