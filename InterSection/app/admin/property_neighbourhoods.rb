ActiveAdmin.register PropertyNeighbourhood do
  permit_params :property_id, :neighbourhood_id, :published
  config.filters = false
  menu label: "Property assignments"
  includes :property, :neighbourhood

  index do
    column :property
    column :neighbourhood
    column :published
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :property
      f.input :neighbourhood
      f.input :published
    end
    f.actions
  end
end
