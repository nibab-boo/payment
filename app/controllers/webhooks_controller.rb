class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!
  def create
    payload = request.body.read
    signature_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.dig(:stripe, :signing_secret)
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, signature_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      render json: { message: e }, status: 400
    rescue Stripe::SignatureVerificationError => e
      render json: { message: e }, status: 400
      return
    end

    case event.type

    when 'checkout.session.completed'
      # return if !User.exists?(event.data.object.client_reference_id)

      fullfill_order(event.data.object)
      
    when 'checkout.session.async_payment_succeeded'

    when 'invoice.payment_succeeded'
      # Return if subscription id isn't present on the invoice
      return unless event.data.object.subscription.present?
      # Continue to provision subscription when payment is made
      # Store the status on local Subscription
      stripe_subscription = Stripe::Subscription.retrieve(event.data.object.subscription)

      subscription = Subscription.find_by(subscription_id: stripe_subscription )

      subscription.update(
        current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
        current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
        plan_id: stripe_subscription.plan.id,
        interval: stripe_subscription.plan.interval,
        status: stripe_subscription.status
      )

    when 'invoice.payment_failed'
      # The payment failed or the payment is not valid
      # The subscription becomes past_due.
      # Notify customer and send them to the customer portal
      user = User.find_by(stripe_id: event.data.object.customer)
      if user.exists?
        SubscriptionMailer.with(user: user).payment_failed.deliver_now
      end
    when 'invoice.subscription.updated'

    else
      puts "Unhandled event type: #{event.type}"
    end
    render json: { message: "success" } 
  end

  private

  def fullfill_order(checkout_session)
    # find the user and assign customer id from stripe
    user = User.find(checkout_session.client_reference_id)
    user.update(stripe_id: checkout_session.customer)
    # retreive new subscription via Stripe using subscription id
    byebug
    stripe_subscription = Stripe::Subscription.retrieve(checkout_session.subscription)

    # Create a new Subscription with Stripe detail and user detail
    Subscription.create!(
      customer_id: stripe_subscription.customer,
      current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
      current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
      interval: stripe_subscription.plan.interval,
      status: stripe_subscription.status,
      subscription_id: stripe_subscription.id,
      plan_id: stripe_subscription.plan.id,
      user: user
    )
  end
end
