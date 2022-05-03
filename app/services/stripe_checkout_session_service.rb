class StripeCheckoutSessionService
  def call(event)
    current_user.subscribed = "premimum"
    p event
  end
end