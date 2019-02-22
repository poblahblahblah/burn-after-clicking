class CreateSecrets < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'pgcrypto'

    create_table :secrets, id: :uuid do |t|
      t.string :title
      t.string :password
      t.text :encrypted_body
      t.text :encrypted_body_salt
      t.datetime :expiration

      t.timestamps
    end
  end
end
