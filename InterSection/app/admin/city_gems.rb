ActiveAdmin.register CityGem do
  permit_params :title, :short_desc, :long_desc, :image, :location, :category_id, :tag_id, :neighbourhood_id, :published
  config.filters = false
  includes :category, :tag, :neighbourhood

  index do
    column :title
    column :location
    column :category
    column :tag
    column :neighbourhood
    column :published
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :title
      f.input :short_desc
      f.input :long_desc
      f.input :image, as: :url, hint: "Public image URL"
      f.input :location
      f.input :category
      f.input :tag
      f.input :neighbourhood
      f.input :published
    end
    f.actions
  end
end
