# == Schema Information
#
# Table name: hospitals
#
#  id         :bigint           not null, primary key
#  name       :string
#  state_id   :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Hospital < ApplicationRecord
  include Seedable

  def self.values
    [
      "DH, Yadgiri",
      "RIMS, Raichur",
      "DH, Vizianagaram",
      "GMH, Tirupati",
      "GGH, Kadappa",
      "SVRRGGH, Tirupati",
      "KGH, Vishakhapatnam",
      "Niloufer Hospital, Hyderabad",
      "DH, Proaddatur",
      "VGH, Vishakhapatnam"
    ]
  end

  belongs_to :state, optional: true

end
