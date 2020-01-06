require_relative 'config/environment'
require 'prometheus_exporter/server'

health_and_metrics = Rack::Builder.app do
  map '/healthz' do
    use Rack::Auth::Basic, 'HealthCheck' do |username, password|
      Rack::Utils.secure_compare(ENV['HEALTH_PASS'], "#{username}:#{password}")
    end

    use Rack::Deflater
    run ->(_) { [200, { 'Content-Type' => 'text/html' }, ['up']] }
  end

  server = PrometheusExporter::Server::WebServer.new port: 9394
  server.start

  run Rails.application
end

run health_and_metrics
