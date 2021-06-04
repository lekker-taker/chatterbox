# Servise to populate elastic with reviews data.
# BE AWARE it resets index before indexing new data.
#
# @example Read IO like data source with JSON
# data = StringIO.new "[{comment: 'good'}]"
#
# ImportService.call(data)
#
class ImportService < ApplicationService
  INDEX_NAME = ENV.fetch('REVIEWS_INDEX_NAME')
  BATCH_SIZE = 5000
  attr_reader :data, :client, :block

  def initialize(data, block: false) # rubocop:disable Lint/MissingSuper
    @data = JSON.parse(data.read)
    @client = Elasticsearch::Client.new
    @block
  end

  def call
    reset_index!

    import(format(data))
  end

  private

  def import(dataset)
    dataset.each_slice(BATCH_SIZE) do |chunk|
      client.bulk(body: Elasticsearch::API::Utils.__bulkify(chunk), refresh: !!block)
    end
  end

  def format(reviews)
    reviews.map! do |r|
      id = r.delete("id")
      r["themes"].map! { |theme| theme.merge(category_id: Theme.find(theme["theme_id"]).category_id) }

      { index: {_index: INDEX_NAME, _id: id, data: r }}
    end
  end

  def reset_index! # rubocop:disable Metrics/MethodLength
    delete_index!

    client.indices.create index: INDEX_NAME, body: {
      mappings: {
        _source: { enabled: false },
        properties: {
          themes: {
            type: :nested,
            properties: {
              theme_id: { type: :keyword },
              category_id: { type: :keyword },
              sentiment: { type: :byte }
            }
          },
          created_at: { type: :date },
          comment: { type: :text }
        }
      }
    }
  end

  def delete_index!
    client.indices.delete index: INDEX_NAME
  rescue Elasticsearch::Transport::Transport::Errors::NotFound
    # do nothing
  end
end
