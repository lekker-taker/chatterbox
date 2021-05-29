module API
  module V1
    # Exposes review import endpoint
    class Import < Grape::API
      format :binary

      params { requires :reviews, type: File }

      post 'upload' do
        ImportService.call(params[:reviews])
      end
    end
  end
end
