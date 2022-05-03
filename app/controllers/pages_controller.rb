class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def subscribe
    price_id = params[:priceId]

    @session = Stripe::Checkout::Session.create({
      success_url: root_url,
    cancel_url: subscribe_url,
      mode: 'subscription',
      line_items: [{
        # For metered billing, do not pass quantity
        quantity: 1,
        price: price_id,
      }],
    })
  end

  def payment

  end
end
