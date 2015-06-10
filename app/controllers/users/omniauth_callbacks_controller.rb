# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
class Devise::OmniauthCallbacksController
    def self.callback_for(provider)
      class_eval %{
      def #{provider}
        @user = User.find_for_#{provider}_oauth request.env["omniauth.auth"]
         for_persisted(provider, @user) && @user.persisted?
         for_nonpersisted(provider)
      end
      }
    end

    def self.for_persisted(provider, user)
      set_flash_message(:notice, :success,
                        kind: provider.capitalize) if is_navigational_format?
      sign_in_and_redirect user, event: :authentication
    end

    def self.for_nonpersisted(provider)
      session["devise.#{provider}_data"] = env['omniauth.auth']
      redirect_to new_user_registration_url
    end

    [:twitter, :facebook, :vkontakte, :instagram].each do |provider|
      callback_for provider
    end

    def after_sign_in_path_for(resource)
      if resource.email_verified?
        super resource
      else
        finish_signup_path(resource)
      end
    end
  end
