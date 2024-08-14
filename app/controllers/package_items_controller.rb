class PackageItemsController < ApplicationController
  def new
    @item = PackageItem.new
    @venue = Venue.find(params[:venue_id])
  end

  def create
    @item = PackageItem.new(item_params)
    @item.venue_id = params[:venue_id]


    if @item.save
      redirect_to dashboard_path(current_user)
    else
      render :new ,status: :unprocessable_entity
    end
  end

  def index
    @venue_items = PackageItem.find(params[:venue_id])
    @venue = Venue.find(params[:venue_id])
    @booking_items = Booking.find(params[:booking_id])
    @booking = Booking.find(params[:booking_id])
  end

  def show
    @item = PackageItem.find(params[:id])
  end

  def edit
    @item = PackageItem.find(params[:id])
  end

  def update
    @item = PackageItem.find(params[:id])

    if @item.update(item_params)
      redirect_to dashboard_path(current_user)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item = PackageItem.find(params[:id])
    @item.destroy
    redirect_to dashboard_path(current_user)
  end

  private

  def item_params
    params.require(:package_item).permit(:name, :price, :venue_id, :booking_id)
  end
end
