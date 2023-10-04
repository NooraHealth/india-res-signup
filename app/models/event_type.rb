# == Schema Information
#
# Table name: event_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class EventType < ApplicationRecord

  include Seedable

  def self.values
    [
      :signup,
      :delivery_confirmation,
      :edd_confirmation,
      :dob_confirmation,
      :condition_area_confirmation,
      :unsubscribe
    ]
  end
end
