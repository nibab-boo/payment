class CheckoutsController < ApplicationController

  def show
    current_user.set_payment_processor :stripe
    current_user.payment_processor.customer
    @checkout_session = current_user.payment_processor.checkout(
      mode: "subscription",
      line_items: "price_1KuszXJskFaNBqW0r9s0RKvr"
    )
    # @checkout_session = current_user.payment_processor.subscribe(name: "Basic", plan: "monthly")
  end
end