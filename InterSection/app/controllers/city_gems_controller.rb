class CityGemsController < ApplicationController
  def show
    @property = Property.find(params[:property_id])
    @city_gem = @property.guest_city_gems.includes(:category, :tag, :neighbourhood).find(params[:id])
  end
end
