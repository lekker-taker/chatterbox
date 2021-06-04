require "rails_helper"

RSpec.describe API::V1::Import, type: :request do
  describe "POST /api/v1/reviews" do
    context "no file provided" do
      it "responds with error" do
        post "/api/v1/reviews"
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "invalid file provided" do
      let(:params) do
        {"reviews" => Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/invalid.json", "application/json")}
      end

      it "responds with 422 error" do
        post "/api/v1/reviews", params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "valid JSON provided" do
      let(:params) do
        {"reviews" => Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/valid.json", "application/json")}
      end

      it "is responds with 204" do
        allow(ImportService).to receive(:call)

        post "/api/v1/reviews", params: params
        expect(response).to have_http_status(:no_content)
      end

      it "is calls ImportService" do
        expect(ImportService).to receive(:call).with(an_instance_of(Tempfile))

        post "/api/v1/reviews", params: params
      end
    end
  end
end
