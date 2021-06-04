module API
  module V1
    # Exposes review import endpoint
    class Import < Grape::API
      desc 'Upload reviews', consumes: ['multipart/form-data']
      params { requires :reviews, type: File }

      rescue_from JSON::ParserError do |e|
        error!({error: {message: "Invalid JSON"}}, 422)
      end

      post "reviews" do
        ImportService.call(params.dig("reviews", "tempfile"))
        status 201
        body false
      end
    end
  end
end
