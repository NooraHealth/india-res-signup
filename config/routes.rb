# == Route Map
#
#                                                     Prefix Verb   URI Pattern                                                                                       Controller#Action
#                         res_res_onboarding_whatsapp_signup GET    /res/res_onboarding/whatsapp/signup(.:format)                                                     dh#exotel_wa_signup
#                   res_res_onboarding_update_condition_area POST   /res/res_onboarding/update_condition_area(.:format)                                               whatsapp#update_condition_area
#                                     sdh_modality_selection GET    /sdh/modality_selection(.:format)                                                                 sdh#ivr_modality_selection
#                                     sdh_language_selection GET    /sdh/language_selection(.:format)                                                                 sdh#ivr_language_selection
#                               sdh_condition_area_selection GET    /sdh/condition_area_selection(.:format)                                                           sdh#ivr_condition_area_selection
#                                         sdh_pin_code_input GET    /sdh/pin_code_input(.:format)                                                                     sdh#pin_code_input
#                                 sdh_days_to_delivery_input GET    /sdh/days_to_delivery_input(.:format)                                                             sdh#days_to_delivery_input
#                                sdh_confirm_whatsapp_number GET    /sdh/confirm_whatsapp_number(.:format)                                                            sdh#confirm_whatsapp_number
#                                 sdh_change_whatsapp_number GET    /sdh/change_whatsapp_number(.:format)                                                             sdh#change_whatsapp_number
#                                        sdh_outro_selection GET    /sdh/outro_selection(.:format)                                                                    sdh#outro_message
#                    sdh_check_language_selection_completion GET    /sdh/check_language_selection_completion(.:format)                                                sdh#check_language_selection_complete
#                    sdh_check_modality_selection_completion GET    /sdh/check_modality_selection_completion(.:format)                                                sdh#check_modality_selection_complete
#              sdh_check_condition_area_selection_completion GET    /sdh/check_condition_area_selection_completion(.:format)                                          sdh#check_condition_area_selection_complete
#          sdh_check_whatsapp_number_confirmation_completion GET    /sdh/check_whatsapp_number_confirmation_completion(.:format)                                      sdh#check_whatsapp_number_confirmation_complete
#                                    sdh_check_existing_user GET    /sdh/check_existing_user(.:format)                                                                sdh_orchestration#check_existing_user
#                                     sdh_weeks_since_signup GET    /sdh/weeks_since_signup(.:format)                                                                 sdh_orchestration#weeks_since_signup
#                                            sdh_day_of_week GET    /sdh/day_of_week(.:format)                                                                        sdh_orchestration#day_of_week
#                                    gems_modality_selection GET    /gems/modality_selection(.:format)                                                                gems#ivr_modality_selection
#                                    gems_language_selection GET    /gems/language_selection(.:format)                                                                gems#ivr_language_selection
#                              gems_condition_area_selection GET    /gems/condition_area_selection(.:format)                                                          gems#ivr_condition_area_selection
#                     gems_whatsapp_condition_area_selection POST   /gems/whatsapp_condition_area_selection(.:format)                                                 gems#whatsapp_condition_area_selection
#                                       gems_outro_selection GET    /gems/outro_selection(.:format)                                                                   gems#outro_message
#                               gems_confirm_whatsapp_number GET    /gems/confirm_whatsapp_number(.:format)                                                           gems#confirm_whatsapp_number
#                                gems_change_whatsapp_number GET    /gems/change_whatsapp_number(.:format)                                                            gems#change_whatsapp_number
#                                       gems_unsubscribe_ivr GET    /gems/unsubscribe_ivr(.:format)                                                                   gems#unsubscribe_ivr
#                                  gems_unsubscribe_whatsapp POST   /gems/unsubscribe_whatsapp(.:format)                                                              gems#unsubscribe_whatsapp
#                                gems_retrieve_user_language GET    /gems/retrieve_user_language(.:format)                                                            gems_orchestration#retrieve_language
#                               gems_retrieve_condition_area GET    /gems/retrieve_condition_area(.:format)                                                           gems_orchestration#retrieve_condition_area
#                            gems_retrieve_days_since_signup GET    /gems/retrieve_days_since_signup(.:format)                                                        gems_orchestration#number_of_days_since_signup
#                                   gems_check_existing_user GET    /gems/check_existing_user(.:format)                                                               gems#check_existing_user
#                                        res_update_language PUT    /res/update_language(.:format)                                                                    users#update_language
#                                      res_retrieve_language GET    /res/retrieve_language(.:format)                                                                  users#retrieve_language
#                                    res_update_textit_group POST   /res/update_textit_group(.:format)                                                                users#update_textit_group
#                   res_himachal_pradesh_ivr_initialize_user GET    /res/himachal_pradesh/ivr_initialize_user(.:format)                                               res_onboarding/himachal_pradesh#ccp_ivr_initialize_user
#             res_himachal_pradesh_ivr_select_condition_area GET    /res/himachal_pradesh/ivr_select_condition_area(.:format)                                         res_onboarding/himachal_pradesh#ccp_ivr_select_condition_area
#                             res_himachal_pradesh_qr_signup POST   /res/himachal_pradesh/qr_signup(.:format)                                                         res_onboarding/himachal_pradesh#ccp_qr_signup
#  res_himachal_pradesh_acknowledge_condition_area_selection PUT    /res/himachal_pradesh/acknowledge_condition_area_selection(.:format)                              res_onboarding/himachal_pradesh#ccp_acknowledge_condition_area
#                            res_haryana_ivr_initialize_user GET    /res/haryana/ivr_initialize_user(.:format)                                                        res_onboarding/haryana#ccp_ivr_initialize_user
#                      res_haryana_ivr_select_condition_area GET    /res/haryana/ivr_select_condition_area(.:format)                                                  res_onboarding/haryana#ccp_ivr_select_condition_area
#                                      res_haryana_qr_signup POST   /res/haryana/qr_signup(.:format)                                                                  res_onboarding/haryana#ccp_qr_signup
#           res_haryana_acknowledge_condition_area_selection PUT    /res/haryana/acknowledge_condition_area_selection(.:format)                                       res_onboarding/haryana#ccp_acknowledge_condition_area
#                        unicef_sncu_get_language_preference GET    /unicef_sncu/get_language_preference(.:format)                                                    district_hospitals/unicef_sncu_orchestration#retrieve_language_preference
#                    unicef_sncu_update_language_preferences GET    /unicef_sncu/update_language_preferences(.:format)                                                district_hospitals/unicef_sncu_orchestration#update_language_preference
#                              unicef_sncu_baby_age_in_weeks GET    /unicef_sncu/baby_age_in_weeks(.:format)                                                          district_hospitals/unicef_sncu_orchestration#baby_age_in_weeks
#                                    unicef_sncu_day_of_week GET    /unicef_sncu/day_of_week(.:format)                                                                district_hospitals/unicef_sncu_orchestration#day_of_week
#                               unicef_sncu_ivr_onboard_user GET    /unicef_sncu/ivr_onboard_user(.:format)                                                           district_hospitals/unicef_sncu_orchestration#wa_signup
#                          res_karnataka_ivr_initialize_user GET    /res/karnataka/ivr_initialize_user(.:format)                                                      res_onboarding/karnataka#ccp_ivr_initialize_user
#                    res_karnataka_ivr_select_condition_area GET    /res/karnataka/ivr_select_condition_area(.:format)                                                res_onboarding/karnataka#ccp_ivr_select_condition_area
#         res_karnataka_acknowledge_condition_area_selection PUT    /res/karnataka/acknowledge_condition_area_selection(.:format)                                     res_onboarding/karnataka#ccp_acknowledge_condition_area
#                                 res_karnataka_dh_wa_signup GET    /res/karnataka/dh_wa_signup(.:format)                                                             res_onboarding/karnataka#ccp_dh_signup
#                     res_andhra_pradesh_ivr_initialize_user POST   /res/andhra_pradesh/ivr_initialize_user(.:format)                                                 res_onboarding/andhra_pradesh#ccp_ivr_initialize_user
#                     res_andhra_pradesh_ivr_select_language POST   /res/andhra_pradesh/ivr_select_language(.:format)                                                 res_onboarding/andhra_pradesh#ccp_ivr_select_language
#                               res_andhra_pradesh_qr_signup POST   /res/andhra_pradesh/qr_signup(.:format)                                                           res_onboarding/andhra_pradesh#ccp_qr_signup
#    res_andhra_pradesh_acknowledge_condition_area_selection PUT    /res/andhra_pradesh/acknowledge_condition_area_selection(.:format)                                res_onboarding/andhra_pradesh#acknowledge_condition_area
#                        res_maharashtra_ivr_initialize_user GET    /res/maharashtra/ivr_initialize_user(.:format)                                                    res_onboarding/maharashtra#ccp_ivr_initialize_user
#                  res_maharashtra_ivr_select_condition_area GET    /res/maharashtra/ivr_select_condition_area(.:format)                                              res_onboarding/maharashtra#ccp_ivr_select_condition_area
#                        res_maharashtra_ivr_select_language GET    /res/maharashtra/ivr_select_language(.:format)                                                    res_onboarding/maharashtra#ccp_ivr_select_language
#       res_maharashtra_acknowledge_condition_area_selection PUT    /res/maharashtra/acknowledge_condition_area_selection(.:format)                                   res_onboarding/maharashtra#acknowledge_condition_area
#                res_maharashtra_acknowledge_language_change PUT    /res/maharashtra/acknowledge_language_change(.:format)                                            res_onboarding/maharashtra#acknowledge_language_change
#                                  res_maharashtra_qr_signup POST   /res/maharashtra/qr_signup(.:format)                                                              res_onboarding/maharashtra#ccp_qr_signup
#                               res_maharashtra_dh_wa_signup GET    /res/maharashtra/dh_wa_signup(.:format)                                                           res_onboarding/maharashtra#ccp_dh_signup
#                                    res_punjab_dh_wa_signup GET    /res/punjab/dh_wa_signup(.:format)                                                                res_onboarding/punjab#ccp_dh_signup
#                            res_madhya_pradesh_dh_wa_signup GET    /res/madhya_pradesh/dh_wa_signup(.:format)                                                        res_onboarding/madhya_pradesh#ccp_dh_signup
#                               res_madhya_pradesh_qr_signup POST   /res/madhya_pradesh/qr_signup(.:format)                                                           res_onboarding/madhya_pradesh#ccp_qr_signup
#                     res_madhya_pradesh_ivr_initialize_user GET    /res/madhya_pradesh/ivr_initialize_user(.:format)                                                 res_onboarding/madhya_pradesh#ccp_ivr_initialize_user
#               res_madhya_pradesh_ivr_select_condition_area GET    /res/madhya_pradesh/ivr_select_condition_area(.:format)                                           res_onboarding/madhya_pradesh#ccp_ivr_select_condition_area
#                       res_aiims_nagpur_ivr_initialize_user GET    /res/aiims_nagpur/ivr_initialize_user(.:format)                                                   res_onboarding/aiims_nagpur#ccp_ivr_initialize_user
#                 res_aiims_nagpur_ivr_select_condition_area GET    /res/aiims_nagpur/ivr_select_condition_area(.:format)                                             res_onboarding/aiims_nagpur#ccp_ivr_select_condition_area
#                                 res_aiims_nagpur_qr_signup POST   /res/aiims_nagpur/qr_signup(.:format)                                                             res_onboarding/aiims_nagpur#ccp_qr_signup
#      res_aiims_nagpur_acknowledge_condition_area_selection PUT    /res/aiims_nagpur/acknowledge_condition_area_selection(.:format)                                  res_onboarding/aiims_nagpur#acknowledge_condition_area
#                               tb_karnataka_ivr_unsubscribe GET    /tb/karnataka/ivr_unsubscribe(.:format)                                                           tb/onboarding#ivr_unsubscribe
#                       tb_karnataka_ivr_signup_for_whatsapp GET    /tb/karnataka/ivr_signup_for_whatsapp(.:format)                                                   tb/onboarding#ivr_signup_for_whatsapp
#                          tb_karnataka_whatsapp_unsubscribe POST   /tb/karnataka/whatsapp_unsubscribe(.:format)                                                      tb/onboarding#whatsapp_unsubscribe
#                                        tb_karnataka_create POST   /tb/karnataka/create(.:format)                                                                    tb/onboarding#create
#                         tb_karnataka_acknowledge_wa_signup PUT    /tb/karnataka/acknowledge_wa_signup(.:format)                                                     tb/onboarding#acknowledge_wa_signup
#                tb_karnataka_acknowledge_language_selection PUT    /tb/karnataka/acknowledge_language_selection(.:format)                                            tb/onboarding#acknowledge_language_selection
#                              rch_portal_punjab_create_user POST   /rch_portal/punjab/create_user(.:format)                                                          rch_portal/punjab/onboarding#create
#                                   rch_portal_punjab_import POST   /rch_portal/punjab/import(.:format)                                                               rch_portal/punjab/onboarding#import
#                           rch_portal_punjab_update_profile PUT    /rch_portal/punjab/update_profile(.:format)                                                       rch_portal/punjab/onboarding#update_profile
#                        rch_portal_punjab_link_based_signup POST   /rch_portal/punjab/link_based_signup(.:format)                                                    rch_portal/punjab/onboarding#link_based_signup
#                               rch_portal_punjab_ivr_signup GET    /rch_portal/punjab/ivr_signup(.:format)                                                           rch_portal/punjab/onboarding#ivr_signup
#                        rch_portal_punjab_bulk_import_users POST   /rch_portal/punjab/bulk_import_users(.:format)                                                    rch_portal/punjab/onboarding#bulk_import_users
#                            rch_portal_punjab_import_status POST   /rch_portal/punjab/import_status(.:format)                                                        rch_portal/punjab/onboarding#check_import_status
#                      rch_portal_andhra_pradesh_create_user POST   /rch_portal/andhra_pradesh/create_user(.:format)                                                  rch_portal/andhra_pradesh/onboarding#create
#                           rch_portal_andhra_pradesh_import POST   /rch_portal/andhra_pradesh/import(.:format)                                                       rch_portal/andhra_pradesh/onboarding#import
#                   rch_portal_andhra_pradesh_update_profile PUT    /rch_portal/andhra_pradesh/update_profile(.:format)                                               rch_portal/andhra_pradesh/onboarding#update_profile
#                rch_portal_andhra_pradesh_link_based_signup POST   /rch_portal/andhra_pradesh/link_based_signup(.:format)                                            rch_portal/andhra_pradesh/onboarding#link_based_signup
#                       rch_portal_andhra_pradesh_ivr_signup GET    /rch_portal/andhra_pradesh/ivr_signup(.:format)                                                   rch_portal/andhra_pradesh/onboarding#ivr_signup
#                rch_portal_andhra_pradesh_bulk_import_users POST   /rch_portal/andhra_pradesh/bulk_import_users(.:format)                                            rch_portal/andhra_pradesh/onboarding#bulk_import_users
#                    rch_portal_andhra_pradesh_import_status POST   /rch_portal/andhra_pradesh/import_status(.:format)                                                rch_portal/andhra_pradesh/onboarding#check_import_status
#                      rch_portal_madhya_pradesh_create_user POST   /rch_portal/madhya_pradesh/create_user(.:format)                                                  rch_portal/madhya_pradesh/onboarding#create
#                           rch_portal_madhya_pradesh_import POST   /rch_portal/madhya_pradesh/import(.:format)                                                       rch_portal/madhya_pradesh/onboarding#import
#                   rch_portal_madhya_pradesh_update_profile PUT    /rch_portal/madhya_pradesh/update_profile(.:format)                                               rch_portal/madhya_pradesh/onboarding#update_profile
#                rch_portal_madhya_pradesh_link_based_signup POST   /rch_portal/madhya_pradesh/link_based_signup(.:format)                                            rch_portal/madhya_pradesh/onboarding#link_based_signup
#                       rch_portal_madhya_pradesh_ivr_signup GET    /rch_portal/madhya_pradesh/ivr_signup(.:format)                                                   rch_portal/madhya_pradesh/onboarding#ivr_signup
#                rch_portal_madhya_pradesh_bulk_import_users POST   /rch_portal/madhya_pradesh/bulk_import_users(.:format)                                            rch_portal/madhya_pradesh/onboarding#bulk_import_users
#                    rch_portal_madhya_pradesh_import_status POST   /rch_portal/madhya_pradesh/import_status(.:format)                                                rch_portal/madhya_pradesh/onboarding#check_import_status
#                           rch_portal_acknowledge_wa_signup PUT    /rch_portal/acknowledge_wa_signup(.:format)                                                       rch_portal/webhooks#acknowledge_wa_signup
#                  rch_portal_ivr_update_onboarding_attempts POST   /rch_portal/ivr_update_onboarding_attempts(.:format)                                              rch_portal/webhooks#update_ivr_onboarding_attempts
#                      rch_portal_update_onboarding_attempts POST   /rch_portal/update_onboarding_attempts(.:format)                                                  rch_portal/webhooks#update_ivr_onboarding_attempts
#                             rch_portal_surveycto_wa_signup POST   /rch_portal/surveycto_wa_signup(.:format)                                                         rch_portal/common#surveycto_wa_signup
#                             rch_update_onboarding_attempts POST   /rch/update_onboarding_attempts(.:format)                                                         rch_portal/webhooks#update_ivr_onboarding_attempts
#                res_onboarding_rch_portal_punjab_ivr_signup GET    /res_onboarding/rch_portal/punjab/ivr_signup(.:format)                                            res_onboarding/punjab#rch_ivr_signup
#         res_onboarding_rch_portal_punjab_link_based_signup POST   /res_onboarding/rch_portal/punjab/link_based_signup(.:format)                                     res_onboarding/punjab#rch_link_based_signup
#        res_onboarding_rch_portal_andhra_pradesh_ivr_signup GET    /res_onboarding/rch_portal/andhra_pradesh/ivr_signup(.:format)                                    res_onboarding/andhra_pradesh#rch_ivr_signup
# res_onboarding_rch_portal_andhra_pradesh_link_based_signup POST   /res_onboarding/rch_portal/andhra_pradesh/link_based_signup(.:format)                             res_onboarding/andhra_pradesh#rch_link_based_signup
#        res_onboarding_rch_portal_madhya_pradesh_ivr_signup GET    /res_onboarding/rch_portal/madhya_pradesh/ivr_signup(.:format)                                    res_onboarding/madhya_pradesh#rch_ivr_signup
# res_onboarding_rch_portal_madhya_pradesh_link_based_signup POST   /res_onboarding/rch_portal/madhya_pradesh/link_based_signup(.:format)                             res_onboarding/madhya_pradesh#rch_link_based_signup
#                              rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                           action_mailbox/ingresses/postmark/inbound_emails#create
#                                 rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                              action_mailbox/ingresses/relay/inbound_emails#create
#                              rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                           action_mailbox/ingresses/sendgrid/inbound_emails#create
#                        rails_mandrill_inbound_health_check GET    /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#health_check
#                              rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#create
#                               rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                                       action_mailbox/ingresses/mailgun/inbound_emails#create
#                             rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#index
#                                                            POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#create
#                          new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                                      rails/conductor/action_mailbox/inbound_emails#new
#                         edit_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id/edit(.:format)                                 rails/conductor/action_mailbox/inbound_emails#edit
#                              rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
#                                                            PATCH  /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                                            PUT    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                                            DELETE /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#destroy
#                   new_rails_conductor_inbound_email_source GET    /rails/conductor/action_mailbox/inbound_emails/sources/new(.:format)                              rails/conductor/action_mailbox/inbound_emails/sources#new
#                      rails_conductor_inbound_email_sources POST   /rails/conductor/action_mailbox/inbound_emails/sources(.:format)                                  rails/conductor/action_mailbox/inbound_emails/sources#create
#                      rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                               rails/conductor/action_mailbox/reroutes#create
#                   rails_conductor_inbound_email_incinerate POST   /rails/conductor/action_mailbox/:inbound_email_id/incinerate(.:format)                            rails/conductor/action_mailbox/incinerates#create
#                                         rails_service_blob GET    /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#                                   rails_service_blob_proxy GET    /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                                            GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#                                  rails_blob_representation GET    /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#                            rails_blob_representation_proxy GET    /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                                            GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                                         rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#                                  update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#                                       rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create

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
  post 'res/update_textit_group', to: 'users#update_textit_group'

  ##############################################################################################################
  ##################################################### COMMON ENDPOINTS ########################################################




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
  post 'res/andhra_pradesh/ivr_select_language', to: 'res_onboarding/andhra_pradesh#ccp_ivr_select_language'
  post 'res/andhra_pradesh/qr_signup', to: 'res_onboarding/andhra_pradesh#ccp_qr_signup'
  put 'res/andhra_pradesh/acknowledge_condition_area_selection', to: 'res_onboarding/andhra_pradesh#acknowledge_condition_area'

  ##############################################################################################################
  ##################################################### Andhra Pradesh Endpoints ########################################################



  ##################################################### Maharashtra Endpoints ########################################################
  ##############################################################################################################

  get 'res/maharashtra/ivr_initialize_user', to: 'res_onboarding/maharashtra#ccp_ivr_initialize_user'
  get 'res/maharashtra/ivr_select_condition_area', to: 'res_onboarding/maharashtra#ccp_ivr_select_condition_area'
  get 'res/maharashtra/ivr_select_language', to: 'res_onboarding/maharashtra#ccp_ivr_select_language'

  # post 'res/maharashtra/qr_signup', to: 'res_onboarding/maharashtra#ccp_qr_signup'
  put 'res/maharashtra/acknowledge_condition_area_selection', to: 'res_onboarding/maharashtra#acknowledge_condition_area'
  put 'res/maharashtra/acknowledge_language_change', to: 'res_onboarding/maharashtra#acknowledge_language_change'

  # QR code signup endpoints
  post 'res/maharashtra/qr_signup', to: 'res_onboarding/maharashtra#ccp_qr_signup'

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

  get 'res/madhya_pradesh/dh_wa_signup', to: 'res_onboarding/madhya_pradesh#ccp_dh_signup'
  post 'res/madhya_pradesh/qr_signup', to: 'res_onboarding/madhya_pradesh#ccp_qr_signup'
  get 'res/madhya_pradesh/ivr_initialize_user', to: 'res_onboarding/madhya_pradesh#ccp_ivr_initialize_user'
  get 'res/madhya_pradesh/ivr_select_condition_area', to: 'res_onboarding/madhya_pradesh#ccp_ivr_select_condition_area'

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


  ##################################################### TB Karnataka Endpoints ################################################################
  ###########################################################################################################################

  get 'tb/karnataka/ivr_unsubscribe', to: 'tb/onboarding#ivr_unsubscribe'
  get 'tb/karnataka/ivr_signup_for_whatsapp', to: 'tb/onboarding#ivr_signup_for_whatsapp'
  post 'tb/karnataka/whatsapp_unsubscribe', to: 'tb/onboarding#whatsapp_unsubscribe'
  post 'tb/karnataka/create_user', to: 'tb/onboarding#create'
  put 'tb/karnataka/acknowledge_wa_signup', to: 'tb/onboarding#acknowledge_wa_signup'
  put 'tb/karnataka/acknowledge_language_selection', to: 'tb/onboarding#acknowledge_language_selection'



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

    namespace :madhya_pradesh do
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

    # Madhya Pradesh RCH Endpoints
    get 'rch_portal/madhya_pradesh/ivr_signup', to: 'madhya_pradesh#rch_ivr_signup'
    post 'rch_portal/madhya_pradesh/link_based_signup', to: 'madhya_pradesh#rch_link_based_signup'

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
