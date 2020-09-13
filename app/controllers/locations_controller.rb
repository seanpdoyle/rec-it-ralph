class LocationsController < ApplicationController
  def index
    locations = Location.near(Current.office, 1, unit: :mi)

    render locals: {locations: locations}
  end

  def show
    location = Location.find(params[:id])

    render locals: {location: location}
  end
end
