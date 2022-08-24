# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  name                   :string
#  mobile_number          :string
#  baby_date_of_birth     :datetime
#  date_of_discharge      :datetime
#  incoming_call_date     :datetime
#  program_id             :integer
#  condition_area_id      :integer
#  language_preference_id :integer
#  language_selected      :boolean          default(FALSE)
#  signed_up_to_whatsapp  :boolean          default(FALSE)
#  signed_up_to_ivr       :boolean          default(FALSE)
#  textit_uuid            :string
#  whatsapp_id            :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class User < ApplicationRecord

  belongs_to :program, class_name: "NooraProgram"
  belongs_to :condition_area
  belongs_to :language_preference, class_name: "Language"

end
