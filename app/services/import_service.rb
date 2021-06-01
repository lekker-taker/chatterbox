# Servise to populate elastic with reviews data.
# BE AWARE it resets index before indexing new data.
#
# @example Read IO like data source with JSON
# data = StringIO.new "[{comment: 'good'}]"
#
# ImportService.call(data)
#
class ImportService < ApplicationService
  INDEX_NAME = :reviews
  attr_reader :data, :client

  def initialize(data) # rubocop:disable Lint/MissingSuper
    @data = JSON.parse(data.read)
    @client = Elasticsearch::Client.new
  end

  def call
    reset_index!

    data.each do |r|
      id = r.delete("id")
      r["themes"].map! { |theme| theme.merge(category_id: Theme.find(theme["theme_id"]).category_id) }

      client.index(index: INDEX_NAME, id: id, body: r)
    end
  end

  private

  def reset_index! # rubocop:disable Metrics/MethodLength
    delete_index!

    client.indices.create index: INDEX_NAME, body: {
      mappings: {
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
