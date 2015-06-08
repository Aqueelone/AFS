class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :name, index: true
      t.string   :email, index: true,                 limit: 128,                   null: false
      t.string   :encrypted_password,     limit: 128
      t.string   :reset_password_token,   limit: 256
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.boolean  :is_admin,                           default: false      
      t.boolean  :is_moderator,                           default: false
      t.integer  :sign_in_count
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip,     limit: 128
      t.string   :last_sign_in_ip,        limit: 128
      t.timestamps null: false
    end
  end
end
