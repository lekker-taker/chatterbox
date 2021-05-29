module API
  module V1
    class Base < Grape::API
      mount API::V1::Dashboard
      mount API::V1::Import
      mount API::V1::Themes
    end
  end
end
