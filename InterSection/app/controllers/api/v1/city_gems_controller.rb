module Api
  module V1
    class CityGemsController < ResourcesController
      self.resource_model = CityGem
      self.writable_fields = [:title, :short_desc, :long_desc, :image, :location, :category_id, :tag_id, :neighbourhood_id, :published].freeze
    end
  end
end
