namespace :db do
  desc "This resets elastic index and seeds it with sample data"
  task reset: :environment do
    sample_data = File.open(Rails.root.join("db", "data", "reviews.json"))

    ImportService.call(sample_data)
  end
end
