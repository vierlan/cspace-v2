class VenuesController < ApplicationController
  def index
    @venues = Venue.all
  end

  def top
  end

  def show
    @venue = Venue.find(params[:id])
  end

  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(venue_params)

    if @venue.save
      redirect_to @venue
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @venue = Venue.find(params[:id])
  end

  def update
    @venue = Venue.find(params[:id])
    if @venue.update(venue_params)
      redirect_to @venue
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def category
    @category = params[:category]
    @venues = Venue.where(category: params[:category]).where.not(user: current_user)
    authorize @venues
    if params[:query].present?
      #sql_subquery = "name ILIKE :query OR facilities ILIKE :query OR address ILIKE :query"
      @venues = @venues.where(sql_subquery, query: "%#{params[:query]}%")
    end
  end

  

  def destroy
    @venue = Venue.find(params[:id])
    @venue.destroy

    redirect_to venues_path
  end

  private

  def venue_params
    params.require(:venue).permit(:name, :address, :phone, :website, :amenities, :description)
  end
end
