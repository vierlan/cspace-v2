class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # receive notifications from Stripe
    # https://stripe.com/docs/webhooks/signatures
      payload = request.body.read
      endpoint_secret = Rails.application.credentials.stripe[:webhook_secret]
      event = nil

      begin
        event = Stripe::Event.construct_from(
          JSON.parse(payload, symbolize_names: true)
        )
      rescue JSON::ParserError => e
        # Invalid payload
        render json: {message: e}, ststus: 400
        return
      rescue Stripe::SignatureVerificationError => e
        # Invalid signature
        render json: {message: e}, status: 400
        return
      end
      # Check if webhook signing is configured.
      if endpoint_secret
        # Retrieve the event by verifying the signature using the raw body and secret.
        signature = request.env['HTTP_STRIPE_SIGNATURE'];
        begin
          event = Stripe::Webhook.construct_event(
            payload, signature, endpoint_secret
          )
        rescue Stripe::SignatureVerificationError => e
          render json: {message: e}, status: 400
          return
        end
      end

      # Handle the event
      case event.type
      when 'payment_intent.succeeded'
        payment_intent = event.data.object # contains a Stripe::PaymentIntent
        puts "Payment for #{payment_intent['amount']} succeeded."
        # Then define and call a method to handle the successful payment intent.
        # handle_payment_intent_succeeded(payment_intent)
      when 'payment_method.attached'
        payment_method = event.data.object # contains a Stripe::PaymentMethod
        # Then define and call a method to handle the successful attachment of a PaymentMethod.
        # handle_payment_method_attached(payment_method)
      else
        puts "Unhandled event type: #{event.type}"
      end

      render json: {message: 'success'}
  end
end
