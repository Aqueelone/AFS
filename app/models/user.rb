# create_table :users, force: :cascade do |t|
#   t.string   :name
#   t.string   :email,                  limit: 128,                 null: false
#   t.string   :encrypted_password,     limit: 128
#   t.string   :reset_password_token,   limit: 256
#   t.datetime :reset_password_sent_at
#   t.datetime :remember_created_at
#   t.boolean  :is_admin,                           default: false
#   t.boolean  :is_moderator,                       default: false
#   t.integer  :sign_in_count
#   t.datetime :current_sign_in_at
#   t.datetime :last_sign_in_at
#   t.string   :current_sign_in_ip,     limit: 128
#   t.string   :last_sign_in_ip,        limit: 128
#   t.datetime :created_at,                                         null: false
#   t.datetime :updated_at,                                         null: false
#   t.string   :confirmation_token
#   t.datetime :confirmed_at
#   t.datetime :confirmation_sent_at
# end
#
# add_index :users, [:confirmation_token], name: :index_users_on_confirmation_token, unique: true, using: :btree
# add_index :users, [:email], name: :index_users_on_email, using: :btree
# add_index :users, [:name], name: :index_users_on_name, using: :btree

class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me, 
    :name, :is_admin, :is_moderator, :current_sign_in_at, :current_sign_in_ip
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  validates :password, length: {minimum: 0, maximum: 120}, on: :update, allow_blank: true

  def self.find_for_oauth(auth, signed_in_resource = nil)
    
    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)
    
    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user
puts auth
    # Create the user if needed
    if !user
      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email ? email_is_verified : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com" 
      user = User.where(:email => email).first if email 

      # Create the user if it's a new registration
      if !user
      puts'!!!!'
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
end
