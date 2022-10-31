# == Route Map
#
#                                            Prefix Verb URI Pattern                                                                              Controller#Action
#            res_district_hospitals_whatsapp_signup GET  /res/district_hospitals/whatsapp/signup(.:format)                                        dh#exotel_wa_signup
#      res_district_hospitals_update_condition_area POST /res/district_hospitals/update_condition_area(.:format)                                  whatsapp#update_condition_area
#                            sdh_modality_selection GET  /sdh/modality_selection(.:format)                                                        sdh#modality_selection
#                            sdh_language_selection GET  /sdh/language_selection(.:format)                                                        sdh#language_selection
#                      sdh_condition_area_selection GET  /sdh/condition_area_selection(.:format)                                                  sdh#condition_area_selection
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
#                           gems_modality_selection GET  /gems/modality_selection(.:format)                                                       gems#modality_selection
#                           gems_language_selection GET  /gems/language_selection(.:format)                                                       gems#language_selection
#                     gems_condition_area_selection GET  /gems/condition_area_selection(.:format)                                                 gems#condition_area_selection
#                              gems_outro_selection GET  /gems/outro_selection(.:format)                                                          gems#outro_message
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
  get 'sdh/modality_selection', to: 'sdh#modality_selection'

  # language selection - endpoint that specifies the language selected by the user
  get 'sdh/language_selection', to: 'sdh#language_selection'

  # condition area selection - endpoint that specifies the condition area of the user. ANC or PNC
  get 'sdh/condition_area_selection', to: 'sdh#condition_area_selection'

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

  # the below are APIs being used for orchestrating IVR audios on a weekly basis
  get 'sdh/check_existing_user', to: 'sdh_orchestration#check_existing_user'
  get 'sdh/weeks_since_signup', to: 'sdh_orchestration#weeks_since_signup'
  get 'sdh/day_of_week', to: 'sdh_orchestration#day_of_week'



  ##################################################### GEMS Endpoints ########################################################
  # modality selection - endpoint that specifies the modalities of the user's intervention
  get 'gems/modality_selection', to: 'gems#modality_selection'

  # language selection - endpoint that specifies the language selected by the user
  get 'gems/language_selection', to: 'gems#language_selection'

  # condition area selection - endpoint that specifies the condition area of the user. ANC or PNC
  get 'gems/condition_area_selection', to: 'gems#condition_area_selection'

  # endpoint that plays the right outro message based on the user's modality selection
  get 'gems/outro_selection', to: 'gems#outro_message'


end
