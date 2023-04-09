desc "Updating Whatsapp IDs for all users who signed up for our WA-based service"
task :update_whatsapp_ids => :environment do
  # first extract all users who were created the previous day
  users = User.where('updated_at >= ? AND updated_at <= ?', Date.yesterday.beginning_of_day, Date.yesterday.end_of_day).where(signed_up_to_whatsapp: true).where(whatsapp_id: nil)
  users = User.where('whatsapp_onboarding_date >= ? AND whatsapp_onboarding_date <= ?', Date.parse("01-02-2023").beginning_of_day, Date.parse("28-02-2023").end_of_day).where(signed_up_to_whatsapp: true).where(whatsapp_id: nil)
  logger = Logger.new("#{Rails.root}/log/turn_api/update_whatsapp_ids.log")
  count = 0
  loop do
    set = users[(count*500)..(count+1)*499]
    if set.blank?
      break
    end
    op = TurnApi::RetrieveWhatsappId.(logger, set)
    if op.errors.present?
      logger.warn("Error while retrieving Whatsapp IDs: #{op.errors}")
    end
    count += 1
  end
end