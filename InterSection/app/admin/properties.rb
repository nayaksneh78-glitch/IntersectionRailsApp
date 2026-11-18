ActiveAdmin.register Property do
  permit_params :title, :description, :address
  config.filters = false

  index do
    column :title
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :title
      f.input :address
      f.input :description
    end
    f.actions
  end
end
