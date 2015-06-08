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
# end
#
# add_index :users, [:email], name: :index_users_on_email, using: :btree
# add_index :users, [:name], name: :index_users_on_name, using: :btree

class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  has_one  :dashboard
  has_one  :messenger
  has_many :identities
  
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :is_admin, :is_moderator

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Получить identity пользователя, если он уже существует
    identity = Identity.find_for_oauth(auth)

    # Если signed_in_resource предоставлен оно всегда переписывает существующего пользователя
    # что бы identity не была закрыта случайно созданным аккаунтом.
    # Заметьте, что это может оставить зомби-аккаунты (без прикрепленной identity)
    # которые позже могут быть удалены
    user = signed_in_resource ? signed_in_resource : identity.user

    # Создать пользователя, если нужно
    if user.nil?

      # Получить email пользователя, если его предоставляет провайдер
      # Если email не был предоставлен мы даем пользователю временный и просим
      # пользователя установить и подтвердить новый в следующим шаге через UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Создать пользователя, если это новая запись
      if user.nil?
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

    # Связать identity с пользователем, если необходимо
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
