source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 6.1.3"
gem "tzinfo-data"

# Use sqlite3 as the database for Active Record
gem "elasticsearch"
# Use Puma as the app server
gem "puma", "~> 5.0"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

gem "grape"
gem "grape-entity"
gem "grape-swagger"

group :development, :test do
  gem "pry-byebug"
  gem "rspec-rails"
  gem "standard"
  gem "dotenv-rails", require: 'dotenv/rails-now'
end

group :development do
  gem "listen"
  gem "solargraph"
end
