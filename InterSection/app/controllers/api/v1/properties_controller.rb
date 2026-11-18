module Api
  module V1
    class PropertiesController < ResourcesController
      self.resource_model = Property
      self.writable_fields = [:title, :description, :address].freeze
    end
  end
end
