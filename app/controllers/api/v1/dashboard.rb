module API
  module V1
    # Exposes aggregated sentiment data
    class Dashboard < Grape::API
      params do
        optional :theme, allow_blank: false, values: -> { Theme.theme_names }
        optional :category, allow_blank: false, values: -> { Theme.category_names }
        optional :phrase, allow_blank: false, type: String, desc: 'Filter by phrase in a product review'
        mutually_exclusive :theme, :category
      end

      helpers do
        def theme_id
          params[:theme] && Theme.all.find { |theme| theme.theme_name == params[:theme] }.id
        end

        def category_id
          params[:category] &&
            Theme.all.find { |theme| theme.category_name == params[:category] }.category_id
        end
      end

      get :dashboard do
        DataFetcherService.call(comment: params[:phrase],
                                theme_id: theme_id,
                                category_id: category_id)
      end
    end
  end
end
