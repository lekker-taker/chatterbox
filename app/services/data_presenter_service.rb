#  Converts ES agregation response to simple JSON
#
class DataPresenterService < ApplicationService
  attr_reader :data

  def initialize(data) # rubocop:disable Lint/MissingSuper
    # Flattens nested aggreagation `filtered`
    @data = data.dig("aggregations", "reviews", "filtered") || data.dig("aggregations", "reviews")
  end

  def call
    return if data.nil?

    {
      by_theme: scores(:by_theme),
      by_caterogy: scores(:by_caterogy)
    }
  end

  private

  def scores(type)
    data.dig(type.to_s, "buckets").map { |theme| [theme["key"], theme.dig("average_score", "value")] }.to_h
  end
end
