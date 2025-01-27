class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:logout]

  def home; end

  def logout
    sign_out(current_user)
    redirect_to root_path
  end

  def page
    @page_key = request.path[1..]
    render "pages/#{@page_key}"
  end

  def test
    @user = current_user
    @venue = Venue.find(1)
    @packages = @venue.packages
    @booking = Booking.new
    @venue_owner = @venue.user
  end

end
