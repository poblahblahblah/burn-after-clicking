require 'bcrypt'

class Secret < ApplicationRecord
  attr_accessor :body

  validates :body, presence: true, length: { maximum: 20000, too_long: "%{count} characters is the maximum allowed" }
  validates :password, presence: true, length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }
  validates :expiration, presence: true

  before_save :encrypt_body

  # hash the password before we save it. we will later compare the hashes to
  # make sure the passwords match.
  before_save do |secret|
    unless self.password.empty?
      secret.password = BCrypt::Password.create(self.password, cost: 31)
    end
  end

  private

  def encrypt_body
    salt  = SecureRandom.hex(32)
    pass  = self.password
    key = ActiveSupport::KeyGenerator.new(pass).generate_key(salt, 32)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    data = crypt.encrypt_and_sign(self.body)

    self.encrypted_body_salt = salt
    self.encrypted_body      = data
  end
end
