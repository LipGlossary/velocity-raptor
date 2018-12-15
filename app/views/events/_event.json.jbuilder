json.extract! event, :id, :scheduled_time, :period, :duration, :title, :created_at, :updated_at
json.url event_url(event, format: :json)
