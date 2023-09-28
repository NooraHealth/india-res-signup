json.array! @import_job_items do |job_item|
  json.id job_item.id
  json.status job_item.import_status.name
  json.user_id job_item.user_id
  json.errors job_item.error_message
end