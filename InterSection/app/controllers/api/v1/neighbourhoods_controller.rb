module Api
  module V1
    class NeighbourhoodsController < ResourcesController
      self.resource_model = Neighbourhood
      self.writable_fields = [:title, :description, :pin, :tag_id, :published].freeze
    end
  end
end
