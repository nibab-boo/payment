Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'paytohome', to: 'pages#home'
  post 'subscribe', to: 'pages#subscribe'
  get 'payment', to: 'pages#payment'
  get 'billing', to: 'billing#show'

  get 'pricing', to: 'static#pricing'

  mount StripeEvent::Engine, at: '/stripe-webhooks'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
