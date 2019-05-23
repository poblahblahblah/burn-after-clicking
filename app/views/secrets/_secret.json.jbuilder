json.extract! secret, :id, :body, :password, :expiration, :created_at, :updated_at
json.url secret_url(secret, format: :json)
