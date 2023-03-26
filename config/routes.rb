# == Route Map
#
#                                            Prefix Verb URI Pattern                                                                              Controller#Action
#            res_district_hospitals_whatsapp_signup GET  /res/district_hospitals/whatsapp/signup(.:format)                                        dh#exotel_wa_signup
#      res_district_hospitals_update_condition_area POST /res/district_hospitals/update_condition_area(.:format)                                  whatsapp#update_condition_area
#                            sdh_modality_selection GET  /sdh/modality_selection(.:format)                                                        sdh#ivr_modality_selection
#                            sdh_language_selection GET  /sdh/language_selection(.:format)                                                        sdh#ivr_language_selection
#                      sdh_condition_area_selection GET  /sdh/condition_area_selection(.:format)                                                  sdh#ivr_condition_area_selection
#                                sdh_pin_code_input GET  /sdh/pin_code_input(.:format)                                                            sdh#pin_code_input
#                        sdh_days_to_delivery_input GET  /sdh/days_to_delivery_input(.:format)                                                    sdh#days_to_delivery_input
#                       sdh_confirm_whatsapp_number GET  /sdh/confirm_whatsapp_number(.:format)                                                   sdh#confirm_whatsapp_number
#                        sdh_change_whatsapp_number GET  /sdh/change_whatsapp_number(.:format)                                                    sdh#change_whatsapp_number
#                               sdh_outro_selection GET  /sdh/outro_selection(.:format)                                                           sdh#outro_message
#           sdh_check_language_selection_completion GET  /sdh/check_language_selection_completion(.:format)                                       sdh#check_language_selection_complete
#           sdh_check_modality_selection_completion GET  /sdh/check_modality_selection_completion(.:format)                                       sdh#check_modality_selection_complete
#     sdh_check_condition_area_selection_completion GET  /sdh/check_condition_area_selection_completion(.:format)                                 sdh#check_condition_area_selection_complete
# sdh_check_whatsapp_number_confirmation_completion GET  /sdh/check_whatsapp_number_confirmation_completion(.:format)                             sdh#check_whatsapp_number_confirmation_complete
#                           sdh_check_existing_user GET  /sdh/check_existing_user(.:format)                                                       sdh_orchestration#check_existing_user
#                            sdh_weeks_since_signup GET  /sdh/weeks_since_signup(.:format)                                                        sdh_orchestration#weeks_since_signup
#                                   sdh_day_of_week GET  /sdh/day_of_week(.:format)                                                               sdh_orchestration#day_of_week
#                           gems_modality_selection GET  /gems/modality_selection(.:format)                                                       gems#ivr_modality_selection
#                           gems_language_selection GET  /gems/language_selection(.:format)                                                       gems#ivr_language_selection
#                     gems_condition_area_selection GET  /gems/condition_area_selection(.:format)                                                 gems#ivr_condition_area_selection
#            gems_whatsapp_condition_area_selection POST /gems/whatsapp_condition_area_selection(.:format)                                        gems#whatsapp_condition_area_selection
#                              gems_outro_selection GET  /gems/outro_selection(.:format)                                                          gems#outro_message
#                      gems_confirm_whatsapp_number GET  /gems/confirm_whatsapp_number(.:format)                                                  gems#confirm_whatsapp_number
#                       gems_change_whatsapp_number GET  /gems/change_whatsapp_number(.:format)                                                   gems#change_whatsapp_number
#                              gems_unsubscribe_ivr GET  /gems/unsubscribe_ivr(.:format)                                                          gems#unsubscribe_ivr
#                         gems_unsubscribe_whatsapp POST /gems/unsubscribe_whatsapp(.:format)                                                     gems#unsubscribe_whatsapp
#                       gems_retrieve_user_language GET  /gems/retrieve_user_language(.:format)                                                   gems_orchestration#retrieve_language
#                      gems_retrieve_condition_area GET  /gems/retrieve_condition_area(.:format)                                                  gems_orchestration#retrieve_condition_area
#                   gems_retrieve_days_since_signup GET  /gems/retrieve_days_since_signup(.:format)                                               gems_orchestration#number_of_days_since_signup
#                          gems_check_existing_user GET  /gems/check_existing_user(.:format)                                                      gems#check_existing_user
#                                  mch_hp_wa_signup GET  /mch/hp/wa_signup(.:format)                                                              district_hospitals/hp#wa_signup
#                     mch_hp_change_whatsapp_number GET  /mch/hp/change_whatsapp_number(.:format)                                                 district_hospitals/hp#change_whatsapp_number
#                            mch_hp_initialize_user GET  /mch/hp/initialize_user(.:format)                                                        district_hospitals/hp#initialize_user
#                   res_haryana_ivr_initialize_user GET  /res/haryana/ivr_initialize_user(.:format)                                               district_hospitals/haryana#ivr_initialize_user
#             res_haryana_ivr_select_condition_area GET  /res/haryana/ivr_select_condition_area(.:format)                                         district_hospitals/haryana#ivr_select_condition_area
#                             res_haryana_qr_signup POST /res/haryana/qr_signup(.:format)                                                         district_hospitals/haryana#qr_signup
#  res_haryana_acknowledge_condition_area_selection PUT  /res/haryana/acknowledge_condition_area_selection(.:format)                              district_hospitals/haryana#acknowledge_condition_area
#               unicef_sncu_get_language_preference GET  /unicef_sncu/get_language_preference(.:format)                                           district_hospitals/unicef_sncu_orchestration#retrieve_language_preference
#           unicef_sncu_update_language_preferences GET  /unicef_sncu/update_language_preferences(.:format)                                       district_hospitals/unicef_sncu_orchestration#update_language_preference
#                     unicef_sncu_baby_age_in_weeks GET  /unicef_sncu/baby_age_in_weeks(.:format)                                                 district_hospitals/unicef_sncu_orchestration#baby_age_in_weeks
#                           unicef_sncu_day_of_week GET  /unicef_sncu/day_of_week(.:format)                                                       district_hospitals/unicef_sncu_orchestration#day_of_week
#                     rch_portal_punjab_create_user POST /rch_portal/punjab/create_user(.:format)                                                 rch_portal/punjab/onboarding#create
#                          rch_portal_punjab_import POST /rch_portal/punjab/import(.:format)                                                      rch_portal/punjab/onboarding#import
#               rch_portal_punjab_link_based_signup POST /rch_portal/punjab/link_based_signup(.:format)                                           rch_portal/punjab/onboarding#link_based_signup
#                      rch_portal_punjab_ivr_signup GET  /rch_portal/punjab/ivr_signup(.:format)                                                  rch_portal/punjab/onboarding#ivr_signup
#                  rch_portal_acknowledge_wa_signup PUT  /rch_portal/acknowledge_wa_signup(.:format)                                              rch_portal/webhooks#acknowledge_wa_signup
#             rch_portal_update_onboarding_attempts POST /rch_portal/update_onboarding_attempts(.:format)                                         rch_portal/webhooks#update_onboarding_attempts
#                                rails_service_blob GET  /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#                         rails_blob_representation GET  /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#                                rails_disk_service GET  /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#                         update_rails_disk_service PUT  /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#                              rails_direct_uploads POST /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get 'res/district_hospitals/whatsapp/signup', to: 'dh#exotel_wa_signup'

  # this endpoint updates the condition area of a user based on parameters
  post 'res/district_hospitals/update_condition_area', to: 'whatsapp#update_condition_area'


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






  ##################################################### HP Endpoints ########################################################
  ##############################################################################################################

  get 'mch/hp/wa_signup', to: 'district_hospitals/hp#wa_signup'
  get 'mch/hp/change_whatsapp_number', to: 'district_hospitals/hp#change_whatsapp_number'
  get 'mch/hp/initialize_user', to: 'district_hospitals/hp#initialize_user'

  ##############################################################################################################
  ##################################################### HP Endpoints ########################################################




  ##################################################### Haryana Endpoints ########################################################
  ##############################################################################################################

  get 'res/haryana/ivr_initialize_user', to: 'district_hospitals/haryana#ivr_initialize_user'
  get 'res/haryana/ivr_select_condition_area', to: 'district_hospitals/haryana#ivr_select_condition_area'
  post 'res/haryana/qr_signup', to: 'district_hospitals/haryana#qr_signup'
  put 'res/haryana/acknowledge_condition_area_selection', to: 'district_hospitals/haryana#acknowledge_condition_area'

  ##############################################################################################################
  ##################################################### Haryana Endpoints ########################################################




  ##################################################### UNICEF SNCU Endpoints ########################################################
  ###########################################################################################################################

  get 'unicef_sncu/get_language_preference', to: 'district_hospitals/unicef_sncu_orchestration#retrieve_language_preference'
  get 'unicef_sncu/update_language_preferences', to: 'district_hospitals/unicef_sncu_orchestration#update_language_preference'
  get 'unicef_sncu/baby_age_in_weeks', to: 'district_hospitals/unicef_sncu_orchestration#baby_age_in_weeks'
  get 'unicef_sncu/day_of_week', to: 'district_hospitals/unicef_sncu_orchestration#day_of_week'

  ###########################################################################################################################
  ##################################################### UNICEF SNCU Endpoints ########################################################


  ##################################################### RCH Endpoints ################################################################
  ###########################################################################################################################

  namespace :rch_portal do

    # all endpoints related to Punjab
    namespace :punjab do
      post 'create_user', to: 'onboarding#create'
      post 'import', to: 'onboarding#import'
      post 'link_based_signup', to: 'onboarding#link_based_signup'
      get 'ivr_signup', to: 'onboarding#ivr_signup'
    end


    namespace :andhra_pradesh do

    end

    put 'acknowledge_wa_signup', to: 'webhooks#acknowledge_wa_signup'
    post 'update_onboarding_attempts', to: 'webhooks#update_onboarding_attempts'
  end


  ###########################################################################################################################
  ##################################################### RCH Endpoints ################################################################


end
