ActiveAdmin.register_page "Dashboard" do
  content title: "InterSection" do
    panel "Guest guide" do
      para "Manage properties, neighbourhood assignments, categories, tags, and city gems."
      para "Publish a neighbourhood, its property assignment, and its city gems to display them in the guest guide."
      para link_to("Open guest guide", root_path)
    end
  end
end
