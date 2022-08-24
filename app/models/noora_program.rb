# == Schema Information
#
# Table name: noora_programs
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class NooraProgram < ApplicationRecord

  include Seedable

  def self.values
    [
      :covid_ccp_ka,
      :covid_ccp_pb,
      :unicef_sncu,
      :mch,
      :covid_ccp_mh,
      :covid_ccp_bangladesh,
      :whatsapp_bangladesh,
      :nishtha_tb,
      :cardiology,
      :inpatient,
      :rch
    ]
  end
end
