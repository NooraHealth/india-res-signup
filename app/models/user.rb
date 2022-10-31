# == Schema Information
#
# Table name: users
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  mobile_number             :string
#  baby_date_of_birth        :datetime
#  date_of_discharge         :datetime
#  incoming_call_date        :datetime
#  program_id                :integer
#  condition_area_id         :integer
#  language_preference_id    :integer
#  language_selected         :boolean          default(FALSE)
#  signed_up_to_whatsapp     :boolean          default(FALSE)
#  signed_up_to_ivr          :boolean          default(FALSE)
#  textit_uuid               :string
#  whatsapp_id               :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  hospital_id               :integer
#  whatsapp_mobile_number    :string
#  state_id                  :integer
#  states_id                 :bigint
#  whatsapp_number_confirmed :boolean          default(FALSE)
#
class User < ApplicationRecord

  validates :mobile_number, presence: true

  belongs_to :program, class_name: "NooraProgram", optional: true
  belongs_to :condition_area, optional: true
  belongs_to :language_preference, class_name: "Language"
  belongs_to :hospital, optional: true
  belongs_to :state, optional: true

  has_many :user_signup_trackers
  has_many :active_signups, -> {active_signups}, class_name: "UserSignupTracker"

  # if the field `whatsapp_mobile_number` exists return that, else return mobile number
  def whatsapp_mobile_number
    super() || self.mobile_number
  end

  def international_whatsapp_number
    number = self.whatsapp_mobile_number[1..self.whatsapp_mobile_number.length]
    "+91#{number}"
  end

  def international_mobile_number
    number = self.mobile_number[1..self.mobile_number.length]
    "+91#{number}"
  end

  # this method checks if a user has fully signed up for the SDH program
  def fully_signed_up_for_sdh?
    self.program_id == NooraProgram.id_for(:sdh) &&
      ((self.signed_up_to_whatsapp && self.whatsapp_number_confirmed) || self.signed_up_to_ivr) &&
      self.condition_area_id.present?
  end

  def gems_user?
    self.program_id == NooraProgram.id_for(:gems)
  end

  def fully_signed_up_to_gems?
    gems_user? and (self.signed_up_to_ivr || self.signed_up_to_whatsapp) and self.incoming_call_date.present?
  end

end
