require_relative 'config/environment'
require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

health_and_metrics = Rack::Builder.app do
  use Prometheus::Middleware::Collector

  map '/healthz' do
    use Rack::Auth::Basic, 'HealthCheck' do |username, password|
      Rack::Utils.secure_compare(ENV['HEALTH_PASS'], "#{username}:#{password}")
    end

    use Rack::Deflater
    run ->(_) { [200, { 'Content-Type' => 'text/html' }, ['up']] }
  end

  map '/metrics' do

    # Commented out until I can work out K8s + Prometheus Basic auth
    #use Rack::Auth::Basic, 'Prometheus Metrics' do |username, password|
    #  Rack::Utils.secure_compare(ENV['METRICS_PASS'], "#{username}:#{password}")
    #end

    use Rack::Deflater
    use Prometheus::Middleware::Exporter, path: ''
    run ->(_) { [500, { 'Content-Type' => 'text/html' }, ['metrics endpoint is unreachable!']] }

  end

  run Rails.application
end

run health_and_metrics
