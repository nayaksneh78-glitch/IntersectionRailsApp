require "rails_helper"

RSpec.describe "InterSection routes", type: :routing do
  it "routes a property guide and its nested gem details" do
    expect(get: "/properties/7").to route_to("properties#show", id: "7")
    expect(get: "/properties/7/city_gems/12").to route_to("city_gems#show", property_id: "7", id: "12")
  end

  it "routes the JSON import and admin entry points" do
    expect(post: "/api/v1/property_neighbourhoods").to route_to("api/v1/property_neighbourhoods#create", format: :json)
    expect(patch: "/api/v1/city_gems/12").to route_to("api/v1/city_gems#update", id: "12", format: :json)
    expect(get: "/admin").to route_to("admin/dashboard#index")
  end
end
