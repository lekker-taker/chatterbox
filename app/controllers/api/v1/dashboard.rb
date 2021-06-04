module API
  module V1
    # Exposes aggregated sentiment data
    class Dashboard < Grape::API
      params do
        optional :theme_id, allow_blank: false, type: Integer
        optional :category_id, allow_blank: false, type: Integer
        optional :phrase, as: :comment, allow_blank: false, type: String, desc: "Filter by phrase in a product review"
        mutually_exclusive :theme, :category
      end

      get :dashboard do
        raw_data = DataFetcherService.call(**declared(params).symbolize_keys)

        DataPresenterService.call(raw_data)
      end
    end
  end
end
