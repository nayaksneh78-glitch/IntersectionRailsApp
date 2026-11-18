module Api
  module V1
    class PropertyNeighbourhoodsController < ResourcesController
      self.resource_model = PropertyNeighbourhood
      self.writable_fields = [:property_id, :neighbourhood_id, :published].freeze
    end
  end
end
