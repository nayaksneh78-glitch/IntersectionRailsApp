module Api
  module V1
    class TagsController < ResourcesController
      self.resource_model = Tag
      self.writable_fields = [:title, :description, :hashtag].freeze
    end
  end
end
