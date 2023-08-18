# == Route Map
#

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get 'res/res_onboarding/whatsapp/signup', to: 'dh#exotel_wa_signup'

  # this endpoint updates the condition area of a user based on parameters
  post 'res/res_onboarding/update_condition_area', to: 'whatsapp#update_condition_area'


  ####################################################### SDH Endpoints #######################################################
  # modality selection - endpoint that specifies the modalities of the user's intervention
  get 'sdh/modality_selection', to: 'sdh#ivr_modality_selection'

  # language selection - endpoint that specifies the language selected by the user
  # TODO - change this endpoint in all flows to reflect the mode in which language is changing
  get 'sdh/language_selection', to: 'sdh#ivr_language_selection'

  # condition area selection - endpoint that specifies the condition area of the user. ANC or PNC
  get 'sdh/condition_area_selection', to: 'sdh#ivr_condition_area_selection'

  # pin code input - endpoint that specifies the pin code of the user entered in either the IVR or chat
  get 'sdh/pin_code_input', to: 'sdh#pin_code_input'

  get 'sdh/days_to_delivery_input', to: 'sdh#days_to_delivery_input'
  get 'sdh/confirm_whatsapp_number', to: 'sdh#confirm_whatsapp_number'
  get 'sdh/change_whatsapp_number', to: 'sdh#change_whatsapp_number'

  # endpoint that plays the right outro message based on the user's modality selection
  get 'sdh/outro_selection', to: 'sdh#outro_message'


  get 'sdh/check_language_selection_completion', to: 'sdh#check_language_selection_complete'
  get 'sdh/check_modality_selection_completion', to: 'sdh#check_modality_selection_complete'
  get 'sdh/check_condition_area_selection_completion', to: 'sdh#check_condition_area_selection_complete'
  get 'sdh/check_whatsapp_number_confirmation_completion', to: 'sdh#check_whatsapp_number_confirmation_complete'


  ################### SDH Orchestration #####################
  # the below are APIs being used for orchestrating IVR audios on a weekly basis
  get 'sdh/check_existing_user', to: 'sdh_orchestration#check_existing_user'
  get 'sdh/weeks_since_signup', to: 'sdh_orchestration#weeks_since_signup'
  get 'sdh/day_of_week', to: 'sdh_orchestration#day_of_week'

  ###########################################################

  #############################################################################################################################
  ####################################################### SDH Endpoints #######################################################






  ##################################################### GEMS Endpoints ########################################################
  #############################################################################################################################
  # modality selection - endpoint that specifies the modalities of the user's intervention
  # This endpoint is for modality selection through IVR
  get 'gems/modality_selection', to: 'gems#ivr_modality_selection'

  # language selection - endpoint that specifies the language selected by the user
  # This is the endpoint for language selection via IVR
  get 'gems/language_selection', to: 'gems#ivr_language_selection'

  # condition area selection - endpoint that collects the condition area of the user through IVR options
  get 'gems/condition_area_selection', to: 'gems#ivr_condition_area_selection'

  # this endpoint updates the condition area of the user based on their selection in the WA bot
  post 'gems/whatsapp_condition_area_selection', to: 'gems#whatsapp_condition_area_selection'

  # endpoint that plays the right outro message based on the user's modality selection
  get 'gems/outro_selection', to: 'gems#outro_message'

  # endpoint that confirms that a user's WA number is the same as their calling number
  get 'gems/confirm_whatsapp_number', to: 'gems#confirm_whatsapp_number'

  # endpoint to change a user's WA number when it's different from their calling number
  get 'gems/change_whatsapp_number', to: 'gems#change_whatsapp_number'

  # this endpoint will unsubscribe users from each modality - IVR or WhatsApp
  get 'gems/unsubscribe_ivr', to: 'gems#unsubscribe_ivr'
  post 'gems/unsubscribe_whatsapp', to: 'gems#unsubscribe_whatsapp'

  ################# GEMS ORCHESTRATION APIs #################
  # endpoint to get the user's language preference from the backend
  get 'gems/retrieve_user_language', to: 'gems_orchestration#retrieve_language'
  # endpoint to get the user's condition area from the backend
  get 'gems/retrieve_condition_area', to: 'gems_orchestration#retrieve_condition_area'
  # endpoint to get the number of days since the user signed up for the program
  get 'gems/retrieve_days_since_signup', to: 'gems_orchestration#number_of_days_since_signup'
  # this endpoint checks if the user has signed up before to the GEMS program
  get 'gems/check_existing_user', to: 'gems#check_existing_user'


  #############################################################################################################################
  ##################################################### GEMS Endpoints ########################################################

  ##################################################### COMMON ENDPOINTS ########################################################
  ##############################################################################################################

  put 'res/update_language', to: 'users#update_language'
  get 'res/retrieve_language', to: 'users#retrieve_language'
  
  ##############################################################################################################
  ##################################################### Himachal Pradesh (HP) Endpoints ########################################################




  ##################################################### Himachal Pradesh (HP) Endpoints ########################################################
  ##############################################################################################################

  get 'res/himachal_pradesh/ivr_initialize_user', to: 'res_onboarding/himachal_pradesh#ccp_ivr_initialize_user'
  get 'res/himachal_pradesh/ivr_select_condition_area', to: 'res_onboarding/himachal_pradesh#ccp_ivr_select_condition_area'
  post 'res/himachal_pradesh/qr_signup', to: 'res_onboarding/himachal_pradesh#ccp_qr_signup'
  put 'res/himachal_pradesh/acknowledge_condition_area_selection', to: 'res_onboarding/himachal_pradesh#ccp_acknowledge_condition_area'

  ##############################################################################################################
  ##################################################### Himachal Pradesh (HP) Endpoints ########################################################




  ##################################################### Haryana Endpoints ########################################################
  ##############################################################################################################

  get 'res/haryana/ivr_initialize_user', to: 'res_onboarding/haryana#ccp_ivr_initialize_user'
  get 'res/haryana/ivr_select_condition_area', to: 'res_onboarding/haryana#ccp_ivr_select_condition_area'
  post 'res/haryana/qr_signup', to: 'res_onboarding/haryana#ccp_qr_signup'
  put 'res/haryana/acknowledge_condition_area_selection', to: 'res_onboarding/haryana#ccp_acknowledge_condition_area'

  ##############################################################################################################
  ##################################################### Haryana Endpoints ########################################################




  ##################################################### UNICEF SNCU Endpoints ########################################################
  ###########################################################################################################################

  get 'unicef_sncu/get_language_preference', to: 'district_hospitals/unicef_sncu_orchestration#retrieve_language_preference'
  get 'unicef_sncu/update_language_preferences', to: 'district_hospitals/unicef_sncu_orchestration#update_language_preference'
  get 'unicef_sncu/baby_age_in_weeks', to: 'district_hospitals/unicef_sncu_orchestration#baby_age_in_weeks'
  get 'unicef_sncu/day_of_week', to: 'district_hospitals/unicef_sncu_orchestration#day_of_week'

  get 'unicef_sncu/ivr_onboard_user', to: 'district_hospitals/unicef_sncu_orchestration#wa_signup'

  ###########################################################################################################################
  ##################################################### UNICEF SNCU Endpoints ########################################################



  ##################################################### Karnataka Endpoints ########################################################
  ##############################################################################################################

  get 'res/karnataka/ivr_initialize_user', to: 'res_onboarding/karnataka#ccp_ivr_initialize_user'
  get 'res/karnataka/ivr_select_condition_area', to: 'res_onboarding/karnataka#ccp_ivr_select_condition_area'
  # post 'res/karnataka/qr_signup', to: 'res_onboarding/karnataka#ccp_qr_signup'
  put 'res/karnataka/acknowledge_condition_area_selection', to: 'res_onboarding/karnataka#ccp_acknowledge_condition_area'

  # Below are the DH signup endpoints
  get 'res/karnataka/dh_wa_signup', to: 'res_onboarding/karnataka#ccp_dh_signup'

  ##############################################################################################################
  ##################################################### Karnataka Endpoints ########################################################



  ##################################################### Andhra Pradesh Endpoints ########################################################
  ##############################################################################################################

  post 'res/andhra_pradesh/ivr_initialize_user', to: 'res_onboarding/andhra_pradesh#ccp_ivr_initialize_user'
  post 'res/andhra_pradesh/ivr_select_condition_area', to: 'res_onboarding/andhra_pradesh#ccp_ivr_select_condition_area'
  post 'res/andhra_pradesh/qr_signup', to: 'res_onboarding/andhra_pradesh#ccp_qr_signup'
  put 'res/andhra_pradesh/acknowledge_condition_area_selection', to: 'res_onboarding/andhra_pradesh#acknowledge_condition_area'

  ##############################################################################################################
  ##################################################### Andhra Pradesh Endpoints ########################################################



  ##################################################### Maharashtra Endpoints ########################################################
  ##############################################################################################################

  get 'res/maharashtra/ivr_initialize_user', to: 'res_onboarding/maharashtra#ccp_ivr_initialize_user'
  get 'res/maharashtra/ivr_select_condition_area', to: 'res_onboarding/maharashtra#ccp_ivr_select_condition_area'
  # post 'res/maharashtra/qr_signup', to: 'res_onboarding/maharashtra#ccp_qr_signup'
  put 'res/maharashtra/acknowledge_condition_area_selection', to: 'res_onboarding/maharashtra#acknowledge_condition_area'

  # Below are the DH signup endpoints
  get 'res/maharashtra/dh_wa_signup', to: 'res_onboarding/maharashtra#ccp_dh_signup'

  ##############################################################################################################
  ##################################################### Maharashtra Endpoints ########################################################



  ##################################################### Punjab Endpoints ########################################################
  ##############################################################################################################

  # Below are the DH signup endpoints
  get 'res/punjab/dh_wa_signup', to: 'res_onboarding/punjab#ccp_dh_signup'

  ##############################################################################################################
  ##################################################### Punjab Endpoints ########################################################



  ##################################################### Madhya Pradesh Endpoints ########################################################
  ##############################################################################################################

  # Below are the DH signup endpoints
  get 'res/madhya_pradesh/dh_wa_signup', to: 'res_onboarding/madhya_pradesh#ccp_dh_signup'

  ##############################################################################################################
  ##################################################### Madhya Pradesh Endpoints ########################################################


  ##################################################### AIIMS Nagpur Endpoints ########################################################
  ##############################################################################################################

  get 'res/aiims_nagpur/ivr_initialize_user', to: 'res_onboarding/aiims_nagpur#ccp_ivr_initialize_user'
  get 'res/aiims_nagpur/ivr_select_condition_area', to: 'res_onboarding/aiims_nagpur#ccp_ivr_select_condition_area'
  post 'res/aiims_nagpur/qr_signup', to: 'res_onboarding/aiims_nagpur#ccp_qr_signup'
  put 'res/aiims_nagpur/acknowledge_condition_area_selection', to: 'res_onboarding/aiims_nagpur#acknowledge_condition_area'

  ##############################################################################################################
  ##################################################### AIIMS Nagpur Endpoints ########################################################



  ##################################################### RCH Ingestion Endpoints ################################################################
  ###########################################################################################################################

  namespace :rch_portal do

    # all endpoints related to Punjab
    namespace :punjab do
      post 'create_user', to: 'onboarding#create'
      post 'import', to: 'onboarding#import'
      put 'update_profile', to: 'onboarding#update_profile'
      post 'link_based_signup', to: 'onboarding#link_based_signup'
      get 'ivr_signup', to: 'onboarding#ivr_signup'

      post 'bulk_import_users', to: 'onboarding#bulk_import_users'
      post 'import_status', to: 'onboarding#check_import_status'
    end

    namespace :andhra_pradesh do
      post 'create_user', to: 'onboarding#create'
      post 'import', to: 'onboarding#import'
      put 'update_profile', to: 'onboarding#update_profile'
      post 'link_based_signup', to: 'onboarding#link_based_signup'
      get 'ivr_signup', to: 'onboarding#ivr_signup'

      post 'bulk_import_users', to: 'onboarding#bulk_import_users'
      post 'import_status', to: 'onboarding#check_import_status'
    end

    put 'acknowledge_wa_signup', to: 'webhooks#acknowledge_wa_signup'
    post 'ivr_update_onboarding_attempts', to: 'webhooks#update_ivr_onboarding_attempts'
    post 'update_onboarding_attempts', to: 'webhooks#update_ivr_onboarding_attempts'

    # this endpoint will be used for signing up a user to WA from SCTO
    post 'surveycto_wa_signup', to: 'common#surveycto_wa_signup'

  end

  ###########################################################################################################################
  ##################################################### RCH Ingestion Endpoints ################################################################


  # put 'rch/acknowledge_wa_signup', to: 'rch_portal/webhooks#acknowledge_wa_signup'
  post 'rch/update_onboarding_attempts', to: 'rch_portal/webhooks#update_ivr_onboarding_attempts'




  ##################################################### RCH Onboarding Endpoints ################################################################
  ###########################################################################################################################

  namespace :res_onboarding do

    # Punjab RCH Endpoints
    get 'rch_portal/punjab/ivr_signup', to: 'punjab#rch_ivr_signup'
    post 'rch_portal/punjab/link_based_signup', to: 'punjab#rch_link_based_signup'

    # Andhra Pradesh RCH Endpoints
    get 'rch_portal/andhra_pradesh/ivr_signup', to: 'andhra_pradesh#rch_ivr_signup'
    post 'rch_portal/andhra_pradesh/link_based_signup', to: 'andhra_pradesh#rch_link_based_signup'

  end

  ###########################################################################################################################
  ##################################################### RCH Onboarding Endpoints ################################################################




  # ##################################################### HP Endpoints (OLD) ########################################################
  # ##############################################################################################################
  # #### DEPRECATED ###
  #
  # get 'mch/hp/wa_signup', to: 'district_hospitals/hp#wa_signup'
  # get 'mch/hp/change_whatsapp_number', to: 'district_hospitals/hp#change_whatsapp_number'
  # get 'mch/hp/initialize_user', to: 'district_hospitals/hp#initialize_user'
  #
  # #### DEPRECATED ###
  # ##############################################################################################################
  # ##################################################### HP Endpoints (OLD) ########################################################
  #

end
