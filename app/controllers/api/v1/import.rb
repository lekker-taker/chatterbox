module API
  module V1
    # Exposes review import endpoint
    class Import < Grape::API
      format :binary

      params { requires :reviews, type: File }

      post "reviews" do
        ImportService.call(params.dig("reviews", "tempfile"))
      end
    end
  end
end
