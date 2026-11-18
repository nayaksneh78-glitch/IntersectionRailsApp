require "rails_helper"

RSpec.describe "Guest guide" do
  let(:property) { create(:property) }
  let(:neighbourhood) { create(:neighbourhood) }

  before { create(:property_neighbourhood, property: property, neighbourhood: neighbourhood) }

  it "combines category and tag filters" do
    selected = create(:city_gem, neighbourhood: neighbourhood)
    same_tag = create(:city_gem, neighbourhood: neighbourhood, tag: selected.tag)
    same_category = create(:city_gem, neighbourhood: neighbourhood, category: selected.category)

    get property_path(property), params: { category_id: selected.category_id, tag_id: selected.tag_id }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include(selected.title, "Google Maps")
    expect(response.body).not_to include(same_tag.title, same_category.title)
  end

  it "hides drafts and gems outside the property, including direct links" do
    draft = create(:city_gem, neighbourhood: neighbourhood, published: false)
    unassigned = create(:city_gem)
    hidden_neighbourhood = create(:neighbourhood, published: false)
    create(:property_neighbourhood, property: property, neighbourhood: hidden_neighbourhood)
    hidden_globally = create(:city_gem, neighbourhood: hidden_neighbourhood)
    hidden_assignment = create(:property_neighbourhood, property: property, published: false)
    hidden_locally = create(:city_gem, neighbourhood: hidden_assignment.neighbourhood)
    hidden_gems = [draft, unassigned, hidden_globally, hidden_locally]

    get property_path(property)
    expect(response).to have_http_status(:ok)
    expect(response.body).not_to include(*hidden_gems.map(&:title))

    hidden_gems.each do |gem|
      get property_city_gem_path(property, gem)
      expect(response).to have_http_status(:not_found)
    end
  end

  it "renders an assigned, published gem with its map link" do
    gem = create(:city_gem, neighbourhood: neighbourhood)
    get property_city_gem_path(property, gem)
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(gem.title, "https://www.google.com/maps/search/")
  end
end
