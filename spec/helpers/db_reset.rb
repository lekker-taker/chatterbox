module DBHelpers
  def db_reset!
    Rails.application.load_tasks
    Rake::Task["db:reset"].invoke
  end
end
