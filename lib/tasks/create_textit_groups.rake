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
  logger = Logger.new("#{Rails.root}/log/create_textit_groups.log")

  # first read the file from disk where the dump is stored
  groups_dump_file = File.read("#{Rails.root}/lib/tasks/textit_groups.json")
  parsed_json = JSON.parse(groups_dump_file)

  parsed_json.each do |group_details|
    textit_id = group_details["uuid"]
    name = group_details["name"]

    # now create the textit group in the database
    textit_group = TextitGroup.new(
      textit_id: textit_id,
      name: name
    )
    unless textit_group.save
      logger.warn "Textit group creation failed with errors: #{textit_group.errors.full_messages}"
    end
  end
end