Rails.application.routes.draw do
  get "/private/health-check", to: ->(_) { [200, {}, ["ok"]] }
  root to: ->(_) { [404, {}, []] }
  # API routes
  mount API::Base, at: "/"
end
