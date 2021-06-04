#  The service object to fetch aggregated review data
#
#  @example Get all data
#
#  DataFetcherService.call
#
#  @example Only include reviews matching comment and category_id
#
#  DataFetcherService.call(comment: "update", category_id: 1234)
#
class DataFetcherService < ApplicationService
  INDEX_NAME = ENV.fetch("REVIEWS_INDEX_NAME")
  attr_reader :comment, :theme_id, :category_id, :client

  def initialize(comment: nil, theme_id: nil, category_id: nil) # rubocop:disable Lint/MissingSuper
    @comment = comment
    @theme_id = theme_id
    @category_id = category_id
    @client = Elasticsearch::Client.new
  end

  def call
    query = comment ? { bool: { must: { match: { comment: comment } } } } : { match_all: {} }

    client.search index: :reviews, size: 0, body: { query: query,
                                                    aggs: { themes: { nested: { path: :themes },
                                                                      **nested_aggregation } } }
  end

  private

  def nested_aggregation
    filter = { filter: { term: { "themes.theme_id" => theme_id } } } if theme_id
    filter = { filter: { term: { "themes.category_id" => category_id } } } if category_id

    return inner_aggregation if filter.nil?

    { aggs: { filtered: { **filter, **inner_aggregation } } }
  end

  def inner_aggregation # rubocop:disable Metrics/MethodLength
    {
      aggs: {
        by_theme: {
          terms: { field: "themes.theme_id" },
          aggs: { average_score: { avg: { field: "themes.sentiment" } } }
        },
        by_caterogy: {
          terms: { field: "themes.category_id" },
          aggs: { average_score: { avg: { field: "themes.sentiment" } } }
        }
      }
    }
  end
end
