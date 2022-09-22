# == Route Map
#
#                                 Prefix Verb URI Pattern                                                                              Controller#Action
# res_district_hospitals_whatsapp_signup GET  /res/district_hospitals/whatsapp/signup(.:format)                                        whatsapp#dh_signup
#                     rails_service_blob GET  /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#              rails_blob_representation GET  /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#                     rails_disk_service GET  /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#              update_rails_disk_service PUT  /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#                   rails_direct_uploads POST /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

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
  get 'sdh/outro_message', to: 'sdh#outro_message'


  get 'sdh/check_language_selection_completion', to: 'sdh#check_language_selection_complete'
  get 'sdh/check_modality_selection_completion', to: 'sdh#check_modality_selection_complete'
  get 'sdh/check_condition_area_selection_completion', to: 'sdh#check_condition_area_selection_complete'
  get 'sdh/check_whatsapp_number_confirmation_completion', to: 'sdh#check_whatsapp_number_confirmation_complete'

end
