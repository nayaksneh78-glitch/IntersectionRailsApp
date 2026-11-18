require "rails_helper"

RSpec.describe "Active Admin" do
  it "requires authentication and displays the sign-in page" do
    get admin_root_path
    expect(response).to redirect_to(new_admin_user_session_path)
    follow_redirect!
    expect(response).to have_http_status(:ok)
  end

  it "renders the registered gem creation form for an operator" do
    operator = create(:admin_user)
    post admin_user_session_path, params: { admin_user: { email: operator.email, password: operator.password } }
    expect(response).to have_http_status(:redirect)

    get new_admin_city_gem_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("city_gem[published]")
  end
end
