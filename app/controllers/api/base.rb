module API
  class Base < Grape::API
    format :json
    prefix :api
    mount API::V1::Base

    add_swagger_documentation
  end
end
