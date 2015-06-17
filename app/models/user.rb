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
# add_index :users, [:confirmation_token],
#          name: :index_users_on_confirmation_token, unique: true, using: :btree
# add_index :users, [:email], name: :index_users_on_email, using: :btree
# add_index :users, [:name], name: :index_users_on_name, using: :btree
class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  has_many :identities

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :name, :is_admin, :is_moderator, :current_sign_in_ip
  validates :email, format: { without: TEMP_EMAIL_REGEX }, on: :update
  validates :password, length: { minimum: 0, maximum: 120 },
                       on: :update, allow_blank: true

  def self.find_for_oauth(auth, signed_in_resource = nil)
    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    user = signed_in_resource ? signed_in_resource : identity.user

    # find the existant user by email
    !user && user = get_user_by_email_and_auth(auth)

    # Create the user if it's a new registration
    !user && user = create_user_by_auth(auth)

    # Associate the identity with the user if needed
    identity.user != user && identity.user = user
    identity.save!
    user
  end

  def self.get_user_by_email_and_auth(auth)
    # Get the existing user by email if the provider gives us a verified email.
    # If no verified email was provided we assign a temporary email and ask the
    # user to verify it on the next step via UsersController.finish_signup
    User.find_by_email(get_email_by_auth(auth))
  end

  def self.create_user_by_auth(auth)
    user = User.new(
      name: auth.extra.raw_info.name,
      email: get_email_by_auth(auth),
      password: Devise.friendly_token[0, 20]
    )
    user.save!
    user
  end

  def self.get_email_by_auth(auth)
    if auth.info.email
      auth.info.email
    else
      "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
    end
  end
  
  def email_verified?
    email && email !~ TEMP_EMAIL_REGEX
  end

  class << self
    def serialize_from_session(key,salt)
      record = to_adapter.get(key[0].to_param)
      record if record && record.authenticatable_salt == salt
    end
  end
end
