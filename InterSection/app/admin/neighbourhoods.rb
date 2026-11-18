ActiveAdmin.register Neighbourhood do
  permit_params :title, :description, :pin, :tag_id, :published
  config.filters = false
  includes :tag

  index do
    column :title
    column :tag
    column :published
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :title
      f.input :description
      f.input :pin, hint: "Latitude, longitude"
      f.input :tag
      f.input :published
    end
    f.actions
  end
end
