class UserMailer < ApplicationMailer
  def welcome(user, password, venue)
    mail(
      to: user.email,
      subject: "Welcome to #{Rails.application.credentials.company_name}!",
      content_type: "text/html",
      body: "<html><body><h1>Welcome to Coomon-Space!</h1><p>Thank you for signing up!</p>
      <p>Your account has been created. Please use the following credentials to log in:</p>
      <p>Your email has been added as the owner of <bold>#{venue}</bold></p>
      <p>Email: #{user.email}</p>
      <p>Password: #{password}</p>
              </body></html>"
    )
  end

  def claim(user, venue)
    mail(
      to: user.email,
      subject: "Claim your venue, #{venue} on #{Rails.application.credentials.company_name}!",
      content_type: "text/html",
      body: "<html><body><h1>Welcome to CareTilt!</h1><p>Thank you for signing up!</p>
      <p>Your account has been created. Please use the following credentials to log in:</p>
      <p>Your email has been added as the owner of #{venue}</p>
      <p>Email: #{user.email}</p>
              </body></html>"
    )

  end

  def offer_setup_assistance(user)
    @user = user
    mail(to: user.email, subject: 'can we help you get set up?')
  end
end
