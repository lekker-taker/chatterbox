module API
  module V1
    class Base < Grape::API
      version :v1, using: :path

      mount API::V1::Dashboard
      mount API::V1::Import
      mount API::V1::Themes
    end
  end
end
