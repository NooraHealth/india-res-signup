ActiveAdmin.register Exophone do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :virtual_number, :language_id, :condition_area_id, :program_id, :state_id
  #
  # or
  #
  permit_params do
    permitted = [:virtual_number, :language_id, :condition_area_id, :program_id, :state_id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  
end
