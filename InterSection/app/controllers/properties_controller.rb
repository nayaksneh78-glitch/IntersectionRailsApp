class PropertiesController < ApplicationController
  def index
    @properties = Property.order(:title, :id).load
    redirect_to property_path(@properties.first) if params[:select].blank? && @properties.size == 1
  end

  def show
    @property = Property.find(params[:id])
    @neighbourhoods = @property.guest_neighbourhoods.order(:title, :id)
    available_gems = @property.guest_city_gems
    @categories = Category.where(id: available_gems.select(:category_id)).order(:title, :id)
    @tags = Tag.where(id: available_gems.select(:tag_id)).order(:title, :id)
    @category = @categories.find_by(id: params[:category_id])
    @tag = @tags.find_by(id: params[:tag_id])
    @neighbourhood = @neighbourhoods.find_by(id: params[:neighbourhood_id])

    @city_gems = available_gems.includes(:category, :tag, :neighbourhood).order(:title, :id)
    @city_gems = @city_gems.where(category: @category) if @category
    @city_gems = @city_gems.where(tag: @tag) if @tag
    @city_gems = @city_gems.where(neighbourhood: @neighbourhood) if @neighbourhood
    @city_gems = @city_gems.to_a.uniq { |gem| [gem.title, gem.location] }
  end
end
