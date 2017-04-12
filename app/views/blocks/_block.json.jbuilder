json.extract! block, :id, :type, :start_time, :duration, :event_id, :title, :created_at, :updated_at
json.url block_url(block, format: :json)
