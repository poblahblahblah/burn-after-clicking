require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

if ['development', 'test'].include?(ENV['RAILS_ENV'])
  # Load up Dotenv as soon as possible
  Dotenv::Railtie.load
end

module BurnAfterClicking
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.action_controller.forgery_protection_origin_check = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # enable longer uuids for the primary key (postgres only)
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    # filter out the password and body from being logged
    config.filter_parameters += [
      :password,
      :body
    ]

    # Rack attack to slow down clients
    config.middleware.use Rack::Attack
  end
end
