ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :mobile_number, :baby_date_of_birth, :date_of_discharge, :incoming_call_date, :program_id, :condition_area_id, :language_preference_id, :language_selected, :signed_up_to_whatsapp, :signed_up_to_ivr, :textit_uuid, :whatsapp_id, :hospital_id, :whatsapp_mobile_number, :state_id, :states_id, :whatsapp_number_confirmed, :ivr_unsubscribe_date, :whatsapp_unsubscribe_date, :last_menstrual_period, :expected_date_of_delivery, :onboarding_method_id, :whatsapp_onboarding_date, :onboarding_attempts, :qr_scan_date, :registered_on_whatsapp, :reference_user_id, :tb_diagnosis_date, :whatsapp_unsubscribed_date, :present_on_wa
  #
  # or
  #
  permit_params do
    permitted = [:name, :mobile_number, :baby_date_of_birth, :date_of_discharge, :incoming_call_date, :program_id, :condition_area_id, :language_preference_id, :language_selected, :signed_up_to_whatsapp, :signed_up_to_ivr, :textit_uuid, :whatsapp_id, :hospital_id, :whatsapp_mobile_number, :state_id, :states_id, :whatsapp_number_confirmed, :ivr_unsubscribe_date, :whatsapp_unsubscribe_date, :last_menstrual_period, :expected_date_of_delivery, :onboarding_method_id, :whatsapp_onboarding_date, :onboarding_attempts, :qr_scan_date, :registered_on_whatsapp, :reference_user_id, :tb_diagnosis_date, :whatsapp_unsubscribed_date, :present_on_wa]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  
end
