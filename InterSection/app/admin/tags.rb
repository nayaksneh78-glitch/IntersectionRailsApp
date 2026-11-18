ActiveAdmin.register Tag do
  permit_params :title, :description, :hashtag
  config.filters = false

  index do
    column :title
    column :hashtag
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :title
      f.input :description
      f.input :hashtag
    end
    f.actions
  end
end
