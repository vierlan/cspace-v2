class CheckoutsController < ApplicationController
  before_action :authenticate_user!
  def show
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    current_user.set_payment_processor :stripe
    current_user.payment_processor.customer
    @checkout_session = current_user
                        .payment_processor
                        .checkout(
                          mode: 'payment',
                          line_items: 'price_1PpvXoRszoiavRvriwLx0Fqy',
                          success_url: checkout_success_url,
                          cancel_url: checkout_cancel_url,

                        )
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    #@line_items = @session.list_line_items
    @line_items = Stripe::Checkout::Session.list_line_items(params[:session_id])
    # @line_items_data = @line_items.data

  end

  def cancel

  end

  def failure

  end

end
