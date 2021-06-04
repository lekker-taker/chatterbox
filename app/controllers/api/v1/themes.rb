module API
  module V1
    # Exposes theme and cateogry names
    class Themes < Grape::API
      get :themes do
        Theme.all
      end
    end
  end
end
