Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.stripe[:public_key],
  secret_key:      Rails.application.credentials.stripe[:private_key],
  signing_secret:  Rails.application.credentials.stripe[:signing_secret]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]

StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed', StripeCheckoutSessionService.new
end
