desc "Creating textit groups from dump of all groups from Textit"
task :create_textit_groups => :environment do
  # Format of JSON from Textit:
  # [
  #   {
  #             "uuid": "20d3e1d7-1958-467e-affd-8b55b722dd01",
  #             "name": "CCP_ANC_Karnataka_08047093145",
  #             "query": null,
  #             "status": "ready",
  #             "system": false,
  #             "count": 11935
  #   }
  #   .
  #   .
  #   .
  # ]

  # initialize logger to log errors if any
  logger = Logger.new("#{Rails.root}/log/update_campaign_trails_v2/create_textit_groups.log")

  # first read the file from disk where the dump is stored
  groups_dump_file = File.read("#{Rails.root}/log/update_campaign_trails_v2/textit_groups_v2.json")
  parsed_json = JSON.parse(groups_dump_file)

  parsed_json.each do |group_details|
    textit_id = group_details["uuid"]
    name = group_details["name"]
    state = group_details["state"]
    program = group_details["program"]
    condition_area = group_details["condition_area"]

    textit_group = TextitGroup.find_by textit_id: textit_id
    if textit_group.present?
      logger.warn "Textit group already exists with id: #{textit_id}"
      # now update the values of the state, program and condition area if they are empty
      if textit_group.state.blank?
        textit_group.update(state_id: State.id_for(state))
      end
      if textit_group.program.blank?
        textit_group.update(program_id: NooraProgram.id_for(program))
      end
      if textit_group.condition_area.blank?
        textit_group.update(condition_area_id: ConditionArea.id_for(condition_area))
      end
      next
    end

    # now create the textit group in the database
    textit_group = TextitGroup.new(
      textit_id: textit_id,
      name: name,
      state_id: State.id_for(state),
      program_id: NooraProgram.id_for(program),
      condition_area_id: ConditionArea.id_for(condition_area)
    )
    unless textit_group.save
      logger.warn "Textit group creation failed with errors: #{textit_group.errors.full_messages}"
    end
  end
end