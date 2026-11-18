require "rails_helper"

RSpec.describe "Catalogue models" do
  it "normalizes hashtags before checking for duplicates" do
    create(:tag, hashtag: "  #COFFEE  ")
    tag = build(:tag, hashtag: "coffee")
    expect(tag).not_to be_valid
    expect(tag.errors[:hashtag]).to include("has already been taken")
  end

  it "rejects duplicate neighbourhood assignments" do
    assignment = create(:property_neighbourhood)
    duplicate = build(:property_neighbourhood, property: assignment.property, neighbourhood: assignment.neighbourhood)
    expect(duplicate).not_to be_valid
  end

  it "rejects non-web image URLs and encodes map search terms" do
    gem = build(:city_gem, title: "A & B", image: "javascript:alert(1)")
    expect(gem).not_to be_valid
    query = URI.decode_www_form(URI.parse(gem.google_maps_url).query).to_h
    expect(query).to eq("api" => "1", "query" => "A & B, 123 Example Street")
  end

  it "preserves referenced tags and categories until their gems are reassigned" do
    gem = create(:city_gem)
    expect(gem.category.destroy).to be_falsey
    expect(gem.tag.destroy).to be_falsey
  end

  it "removes a deleted neighbourhood's assignments and gems" do
    assignment = create(:property_neighbourhood)
    gem = create(:city_gem, neighbourhood: assignment.neighbourhood)
    assignment.neighbourhood.destroy!
    expect(PropertyNeighbourhood.exists?(assignment.id)).to be(false)
    expect(CityGem.exists?(gem.id)).to be(false)
    expect(Property.exists?(assignment.property_id)).to be(true)
  end
end
