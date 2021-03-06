Rails.application.routes.draw do
  devise_for :users
  mount StripeEvent::Engine, at: '/stripe-webhooks'
  root to: 'pages#home'
  get 'paytohome', to: 'pages#home'
  post 'subscribe', to: 'pages#subscribe'

  resources :billings, only: :create
  get 'pricing', to: 'static#pricing'

  namespace :purchase do
    resources :checkouts
  end

  get 'success', to: 'purchase/checkouts#success'

  resources :subscriptions, only: [:index]

  resources :webhooks, only: [:create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
