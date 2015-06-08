Rails.application.routes.draw do

  get 'users/users'

  devise_for :users
  resources :users
  
  resources :dashboards
  resources :messengers
  
  root :to => 'dashboards#index'
  
  devise_scope :users do
      get "sign_out", :to => "devise/sessions#destroy"
      delete "sign_out", :to => "devise/sessions#destroy"
  end
  
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
end
