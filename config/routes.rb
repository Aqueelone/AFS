Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :users
  resources :dashboards
  resources :messengers
  root to: 'dashboards#index'
  match '/users/:id/finish_signup' => 'users#finish_signup',
        via: [:get, :patch], as: :finish_signup
end
