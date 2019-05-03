class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle('limit creating secrets', limit: 4, period: 1.minutes) do |req|
    if req.path == '/secrets' && req.post?
      req.ip
    end
  end
end
