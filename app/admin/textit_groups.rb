ActiveAdmin.register TextitGroup do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :program_id, :textit_id, :condition_area_id, :exotel_number, :language_id, :state_id, :onboarding_method_id, :qr_code_id, :direct_entry
  #
  # or
  #
  permit_params do
    permitted = [:name, :program_id, :textit_id, :condition_area_id, :language_id, :state_id, :onboarding_method_id, :qr_code_id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  
end
