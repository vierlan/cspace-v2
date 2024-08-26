class StripePackage

  def initialize(params, package)
    @params = params
    @package = package
  end

  def create_package
    return if @package.stripe_id.present?
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    cloudinary_base_url = 'https://res.cloudinary.com/drirqdfbt/image/upload/v1724362903/development/'
    image = "#{cloudinary_base_url}#{@package.photo.key}.jpg"
    stripe_product = Stripe::Product.create(
      name: @package.package_name,
      description: @package.package_description,
      images: [image],
      metadata: {
        user_id: @package.venue.user.id,
        package_id: @package.id,
        venue_id: @package.venue.id
      }
    )
    stripe_price = Stripe::Price.create(
      currency: 'eur',
      unit_amount_decimal: @package.package_price * 100,
      product: stripe_product.id
    )
    @package.update(
      stripe_id: stripe_product.id,
      data: stripe_product.to_json,
      stripe_price_id: stripe_price.id
    )
  end

end
