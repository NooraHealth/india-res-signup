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
#  ivr_unsubscribe_date      :datetime
#  whatsapp_unsubscribe_date :datetime
#  last_menstrual_period     :datetime
#  expected_date_of_delivery :datetime
#  onboarding_method_id      :bigint
#  whatsapp_onboarding_date  :datetime
#  onboarding_attempts       :integer          default(0)
#
class User < ApplicationRecord

  validates :mobile_number, presence: true, uniqueness: true

  belongs_to :program, class_name: "NooraProgram", optional: true
  belongs_to :condition_area, optional: true
  belongs_to :language_preference, class_name: "Language", optional: true
  belongs_to :hospital, optional: true
  belongs_to :state, optional: true
  belongs_to :onboarding_method, optional: true

  has_many :user_signup_trackers, dependent: :destroy

  has_many :active_signups, -> {active_signups}, class_name: "UserSignupTracker"

  has_many :user_condition_area_mappings, dependent: :destroy
  has_many :condition_areas, through: :user_condition_area_mappings


  has_one :rch_profile, dependent: :destroy

  # after_save :update_whatsapp_id TODO - better way to do this

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

  def sdh_user?
    self.program_id == NooraProgram.id_for(:sdh)
  end

  # this method checks if a user has fully signed up for the SDH program
  def fully_signed_up_for_sdh?
    self.program_id == NooraProgram.id_for(:sdh) &&
      ((self.signed_up_to_whatsapp && self.whatsapp_number_confirmed) || self.signed_up_to_ivr) &&
      self.user_condition_area_mappings.with_program_id(NooraProgram.id_for(:sdh)).present?
  end

  def gems_user?
    self.program_id == NooraProgram.id_for(:gems)
  end

  def fully_signed_up_to_gems?
    gems_user? and (self.signed_up_to_ivr || self.signed_up_to_whatsapp) and self.incoming_call_date.present?
  end

  def rch_id
    self.rch_profile&.rch_id
  end


  ######################## CONDITION AREA RELATED METHODS #############################

  # TODO - add an active lag to the user-condition-area mapping table to keep track of which intervention
  # the user is currently a part of. This will, by default, be the one that they signed up last

  # the below functions takes the program as an argument and returns the
  # ID of the latest condition area in that program that the user belongs to
  def retrieve_condition_area_id(program_id)
    self.user_condition_area_mappings.where(noora_program_id: program_id).first&.condition_area_id
  end


  # the below functions takes the program as an argument and returns the
  # latest condition area in that program that the user belongs to
  def retrieve_condition_area(program_id)
    ConditionArea.find_by(id: self.retrieve_condition_area_id(program_id))
  end


  # this method adds a user to a condition area, for a given program
  def add_condition_area(program_id, condition_area_id)
    if self.user_condition_area_mappings.with_program_id(program_id).pluck(:condition_area_id).include?(condition_area_id)
      # do nothing, because the user already belongs to that particular condition area
    else
      return self.user_condition_area_mappings.build(condition_area_id: condition_area_id, noora_program_id: program_id).save
    end
  end

  # for a given program, it updates the condition area of the user
  # with the condition area passed in the argument
  # USE WITH CAUTION
  def update_condition_area(program_id, new_condition_area_id)
    self.user_condition_area_mappings.where(noora_program_id: program_id).first&.update(condition_area_id: new_condition_area_id)
  end

  # the below method removed the condition area associated with a user
  def remove_condition_area(program_id, condition_area_id)
    self.user_condition_area_mappings.where(noora_program_id: program_id, condition_area_id: condition_area_id).first&.destroy
  end

  ######################## CONDITION AREA RELATED METHODS #############################


  ######################## SIGNUP TRACKER RELATED METHODS #############################

  def add_signup_tracker(program_id, condition_area_id, language_id)
    self.user_signup_trackers.build(condition_area_id: condition_area_id,
                                    program_id: program_id,
                                    language_id: language_id)
  end




  private

  # def update_whatsapp_id
  #   if self.signed_up_to_whatsapp && self.whatsapp_id.blank?
  #     op = TurnApi::UpdateWhatsappId.perform_async(self.id)
  #   end
  # end

end
