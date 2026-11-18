require "rails_helper"

RSpec.describe "Import API" do
  around do |example|
    original = ENV["INTERSECTION_API_TOKEN"]
    ENV["INTERSECTION_API_TOKEN"] = "test-import-secret"
    example.run
  ensure
    ENV["INTERSECTION_API_TOKEN"] = original
  end

  let(:headers) { { "Authorization" => "Bearer test-import-secret" } }

  it "allows unauthenticated reads, including unpublished records" do
    gem = create(:city_gem, published: false)

    get "/api/v1/city_gems"
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.fetch("data").pluck("id")).to include(gem.id)

    get "/api/v1/city_gems/#{gem.id}"
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.dig("data", "published")).to be(false)
  end

  it "requires a valid token for writes" do
    post "/api/v1/properties", params: { property: { title: "The Courtyard" } }, as: :json
    expect(response).to have_http_status(:unauthorized)
  end

  it "supports the property lifecycle via JSON" do
    post "/api/v1/properties", params: { property: { title: "The Courtyard" } }, headers: headers, as: :json
    expect(response).to have_http_status(:created)
    path = URI.parse(response.headers.fetch("Location")).request_uri
    id = response.parsed_body.fetch("data").fetch("id")

    patch path, params: { property: { title: "Courtyard House" } }, headers: headers, as: :json
    expect(response).to have_http_status(:ok)

    get path, headers: headers
    expect(response.parsed_body.fetch("data").fetch("title")).to eq("Courtyard House")

    get "/api/v1/properties", headers: headers
    expect(response.parsed_body.fetch("data").pluck("id")).to include(id)

    delete path, headers: headers
    expect(response).to have_http_status(:no_content)
    expect(Property.exists?(id)).to be(false)
  end

  it "returns field errors for invalid input" do
    post "/api/v1/properties", params: { property: { title: " " } }, headers: headers, as: :json
    expect(response.status).to eq(422)
    expect(response.parsed_body.fetch("errors")).to have_key("title")
  end
end
