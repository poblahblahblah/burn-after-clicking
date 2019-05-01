require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

unless defined?(Rails::Console) || File.split($0).last == 'rake'
  # delete expired secrets every minute with a random delay
  s.every '1m' do
    sleep rand(30)
    expired_secrets = Secret.where("expiration <= ?", Time.now)
    Rails.logger.info "destroying #{expired_secrets.count} secrets"
    expired_secrets.each {|s| s.destroy }
    Rails.logger.flush
  end
end
