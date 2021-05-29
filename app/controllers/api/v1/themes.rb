module API
  module V1
    # Exposes theme and cateogry names
    class Themes < Grape::API
      get :themes do
        { theme_names: Theme.theme_names, category_names: Theme.category_names }
      end
    end
  end
end
