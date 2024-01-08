desc "Updating the UserTextitGroupMapping records for all users from dump"
task :update_textit_group_mappings => :environment do
  logger = Logger.new("#{Rails.root}/log/update_campaign_trails/update_textit_group_mappings.log")
  # first read the file from disk where the dump is stored
  if Rails.env.staging? || Rails.env.production?
    dump_file = File.read("#{Rails.root}/log/update_campaign_trails/users_textit_group_mappings.json")
  else
    dump_file = File.read("#{Rails.root}/lib/tasks/users_textit_group_mappings.json")
  end
  parsed_json = JSON.parse(dump_file)
  # now iterate over each user and create the mapping
  # between the user and the textit group
  # Sample JSON:
  # {
  #   "user_mobile"=>"919009602781",
  #   "date-joined"=>"2023-10-30T17:47:10.939000+05:30",
  #   "textit_groups"=>
  #     [{"uid"=>"9c2344d1-38bb-470e-a784-7c800ad11c66", "name"=>"RCH_Neutral_MP"},
  #      {"uid"=>"a83828f0-6050-4241-9369-017e6eea456b", "name"=>"RCH Neutral MP (IVR)"},
  #      {"uid"=>"ef7a0f2a-13a4-4373-987c-11e336822cad", "name"=>"RCH_ANC_MP_07314621008"}],
  #   "present_on_wa"=>true,
  #   "last_sent_success"=>"2023-11-05T18:30:49.089501Z"
  # }

  parsed_json.each do |user_details|
    # logger.info("JSON: #{user}")

    user_mobile = user_details["user_mobile"]
    if user_mobile.starts_with?("91")
      # i.e. india
      mobile_number = "0#{user_mobile[2..]}"
    elsif user_mobile.starts_with?("880")
      # i.e. Bangladesh
      mobile_number = "0#{user_mobile[3..]}"
      logger.warn("User from Bangladesh found with mobile number: #{mobile_number}")
      next # because we're only interested in India
    elsif user_mobile.starts_with?("61")
      mobile_number = "0#{user_mobile[2..]}"
      logger.warn("User from Indonesia found with mobile number: #{mobile_number}")
      next # because we're only interested in India
    end

    user = User.find_by mobile_number: mobile_number
    if user.blank?
      logger.warn("User not found with mobile number: #{mobile_number}")
      next
    end

    textit_groups = user_details["textit_groups"]

    if textit_groups.blank?
      logger.warn("Textit groups not found for user with mobile number: #{mobile_number}")
      next
    end

    date_joined = user_details["date-joined"]
    parsed_date_joined = DateTime.parse(date_joined) rescue nil

    if parsed_date_joined.blank?
      logger.warn("Date joined not found for user with mobile number: #{mobile_number}")
      next
    end


    textit_groups.each do |group|
      textit_group_id = group["uid"]
      textit_group = TextitGroup.find_by textit_id: textit_group_id

      if textit_group.blank?
        logger.warn("Textit group not found with textit_id: #{textit_group_id} and name #{group["name"]} in the DB")
        next
      end

      if UserTextitGroupMapping.where(user_id: user.id, textit_group_id: textit_group.id).present?
        logger.info("Trail already exists for this campaign and user, user details: #{mobile_number} and group: #{textit_group_id}")
        next
      end

      user_textit_group_mapping = UserTextitGroupMapping.new(
        user_id: user.id,
        textit_group_id: textit_group.id,
        event_timestamp: parsed_date_joined
      )
      unless user_textit_group_mapping.save
        logger.warn("UserTextitGroupMapping not created for user_id: #{user.id} and textit_group_id: #{textit_group_id} because of errors: #{user_textit_group_mapping.errors.full_messages}")
      end
    end

    user.update(present_on_wa: user_details["present_on_wa"])

  end
end