require "rails_helper"

RSpec.describe API::V1::Dashboard, type: :request do
  let(:params) { {} }
  before { get "/api/v1/dashboard", params: params }

  describe "GET /api/v1/dashboard" do
    it "is successful" do
      expect(response).to have_http_status(200)
    end

    describe "JSON response" do
      subject { JSON.parse(response.body) }

      it { is_expected.to include("by_theme", "by_caterogy") }

      context "when no reviews present", :mock_reviews do
        let(:reviews) { StringIO.new "[]" }

        it { is_expected.to eq("by_theme" => {}, "by_caterogy" => {}) }
      end

      context "when single review present", :mock_reviews do
        let(:reviews) do
          StringIO.new <<~JSON
            [{
              "comment": "sometimes difficult to get to log in screen, just keeps buffering. other than that very good and easy to navigate", 
              "themes": [
                  {
                      "theme_id": 6338, 
                      "sentiment": 1
                  }, 
                  {
                      "theme_id": 6374, 
                      "sentiment": 0
                  }, 
                  {
                      "theme_id": 6345, 
                      "sentiment": -1
                  }, 
                  {
                      "theme_id": 6354, 
                      "sentiment": 1
                  }
              ], 
              "created_at": "2019-07-17T12:47:11.000Z", 
              "id": 58948791
            }]
          JSON
        end

        it {
          is_expected.to eq("by_caterogy" => {"1218" => 0.0, "1223" => 0.3333333333333333},
                            "by_theme" => {"6338" => 1.0, "6345" => -1.0, "6354" => 1.0, "6374" => 0.0})
        }
      end

      context "when multiple reviews present", :mock_reviews do
        let(:reviews) do
          StringIO.new <<~JSON
              [{
                "comment": "very good", 
                "themes": [
                    { "theme_id": 6338, "sentiment": 1}, 
                    { "theme_id": 6374, "sentiment": 1}
                ], 
                "created_at": "2019-07-17T12:47:11.000Z", 
                "id": 58948791
              },{
                "comment": "very bad", 
                "themes": [
                  { "theme_id": 6338, "sentiment": -1}, 
                  { "theme_id": 6374, "sentiment": -1}
                ], 
                "created_at": "2019-07-17T12:47:12.000Z", 
                "id": 58948792
              }
            ]
          JSON
        end

        describe "when not filtered" do
          it {
            is_expected.to eq("by_caterogy" => {"1218" => 0.0, "1223" => 0.0},
                              "by_theme" => {"6338" => 0.0, "6374" => 0.0})
          }
        end

        describe "when filterd by catetegory" do
          let(:params) { {category_id: 1218} }
          it {
            is_expected.to eq("by_caterogy" => {"1218" => 0.0},
                              "by_theme" => {"6374" => 0.0})
          }
        end

        describe "when filterd by theme" do
          let(:params) { {theme_id: 6374} }
          it {
            is_expected.to eq("by_caterogy" => {"1218" => 0.0},
                              "by_theme" => {"6374" => 0.0})
          }
        end

        describe "when filterd by theme and category" do
          let(:params) { {category_id: 1223, theme_id: 6345} }
          it "responds with error" do
            expect(response).to have_http_status(200)
          end
        end

        describe "when filterd by word" do
          let(:params) { {phrase: "good"} }
          it {
            is_expected.to eq("by_caterogy" => {"1218" => 1.0, "1223" => 1.0},
                              "by_theme" => {"6338" => 1.0, "6374" => 1.0})
          }
        end

        describe "when filterd by word and theme" do
          let(:params) { {theme_id: 6338, phrase: "good"} }
          it {
            is_expected.to eq("by_caterogy" => {"1223" => 1.0},
                              "by_theme" => {"6338" => 1.0})
          }
        end

        describe "when filterd by phrase and theme" do
          let(:params) { {theme_id: 6338, phrase: '"very good"'} }
          it {
            is_expected.to eq("by_caterogy" => {"1223" => 1.0},
                              "by_theme" => {"6338" => 1.0})
          }
        end
      end
    end
  end
end
