Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :dashboards
  resources :messengers
  root to: 'users/omniauth_callbacks#passthru {:provider=>/vkontakte/}'
  match '/users/:id/finish_signup' => 'users#finish_signup',
        via: [:get, :patch], as: :finish_signup
end
