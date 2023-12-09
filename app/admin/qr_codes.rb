ActiveAdmin.register QrCode do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :link_encoded, :state_id, :noora_program_id, :text_identifier, :condition_area_id, :text_encoded
  #
  # or
  #
  permit_params do
    permitted = [:name, :state_id, :noora_program_id, :text_identifier, :condition_area_id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  
end
