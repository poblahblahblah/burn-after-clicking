class CreateSecrets < ActiveRecord::Migration[5.2]
  def change
    create_table :secrets, id: :uuid do |t|
      t.string :title
      t.text :encrypted_body
      t.text :encrypted_body_iv
      t.string :password
      t.datetime :expiration

      t.timestamps
    end
  end
end
