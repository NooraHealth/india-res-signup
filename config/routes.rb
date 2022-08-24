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
  
  get 'res/district_hospitals/whatsapp/signup', to: 'whatsapp#dh_signup'

  post 'res/district_hospitals/acknowledge_condition_area_change', to: 'whatsapp#update_condition_area'

end
