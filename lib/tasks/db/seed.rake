namespace :db do
  desc "Resets elastic index and seeds with sample data"
  task reset: :environment do
    sample_data = File.open(Rails.root.join("db", "data", "reviews.json"))

    ImportService.call(sample_data, block: true)
  end
end
