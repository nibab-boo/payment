Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'paytohome', to: 'pages#home'
  post 'subscribe', to: 'pages#subscribe'
  get 'subscribe', to: 'pages#payment'
  get 'billing', to: 'billing#show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
