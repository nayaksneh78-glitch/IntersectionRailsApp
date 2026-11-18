module Api
  module V1
    class CategoriesController < ResourcesController
      self.resource_model = Category
      self.writable_fields = [:title, :description].freeze
    end
  end
end
