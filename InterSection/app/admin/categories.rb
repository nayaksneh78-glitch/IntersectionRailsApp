ActiveAdmin.register Category do
  permit_params :title, :description
  config.filters = false

  index do
    column :title
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :title
      f.input :description
    end
    f.actions
  end
end
