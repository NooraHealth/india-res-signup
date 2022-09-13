class SdhController < ApplicationController

  def modality_selection

  end


  def language_selection

  end


  def pin_code_input

  end


  def days_to_delivery

  end


  def confirm_whatsapp_number

  end


  def change_whatsapp_number

  end


  def condition_area_selection

  end


  private

  def sdh_params
    params.permit!
  end
end
