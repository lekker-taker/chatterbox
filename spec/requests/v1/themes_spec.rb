require "rails_helper"

RSpec.describe API::V1::Themes, type: :request do
  describe "GET /api/v1/themes" do
    it "responds with success" do
      get "/api/v1/themes"

      expect(response).to have_http_status(200)
    end

    describe "JSON response" do
      before { get "/api/v1/themes" }
      subject { JSON.parse(response.body) }

      it {
        is_expected.to include(
          {
            "attributes" => {
              "theme_name" => "General",
              "category_name" => "Information",
              "id" => 6374,
              "category_id" => 1218
            }
          }
        )
      }
    end
  end
end
