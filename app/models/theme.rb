#
# ActiveRecord like class providing reference theme & category info.
#
# @example Find category_name for given theme_id
# Theme.find(theme_id).category_name
#
# @example List all valid theme_names
# Theme.theme_names
class Theme
  CATEGORIES_DATA = File.open(Rails.root.join("db", "data", "categories.json"))
  THEMES_DATA = File.open(Rails.root.join("db", "data", "themes.json"))

  include ActiveModel::Model
  include ActiveModel::Attributes
  attribute :theme_name, :string
  attribute :category_name, :string
  attribute :id, :integer
  attribute :category_id, :integer

  class << self
    def all
      @all ||= JSON.parse(THEMES_DATA.read).map do |theme|
        new(id: theme["id"],
            theme_name: theme["name"],
            category_id: theme["category_id"],
            category_name: category_name_by_category_id(theme["category_id"]))
      end
    end

    def find(theme_id)
      @theme_by_id ||= all.map { |theme| [theme.id, theme] }.to_h

      @theme_by_id[theme_id]
    end

    def category_names
      all.map(&:category_name).uniq
    end

    def theme_names
      all.map(&:theme_name)
    end

    def theme_ids
      all.map(&:id)
    end

    def category_name_by_category_id(category_id)
      @category_name_by_category_id ||= JSON
                                        .parse(CATEGORIES_DATA.read)
                                        .pluck("id", "name")
                                        .to_h
      @category_name_by_category_id[category_id]
    end
  end
end
