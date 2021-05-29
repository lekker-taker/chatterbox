# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

# API

Chatterbox app provides 4 API endpoints:

GET /api/swagger_doc.json  -- OpenAPI v2 API schema.

GET /api/dashboard.json -- Provides aggregated sentiment data with theme\category breakdown.
GET /api/themes.json -- Provides full list of valid theme and category names.
POST /api/import  -- Accepts new `reviews.json` file. Populates DB.

CORS allows access from https://editor.swagger.io

# TODO

* Authentication
* Helm chart
* Unit-tests
* Async import

* System dependencies

* Configuration

* Database creation \ initialization

Sample data contained in repo at /db/data.
Themes & categories are loaded on app boot to AR like `Theme` class. And persisted in class variables.

Reviews data persisted in `Elastic`. It could be populated  either from same sample set via rake task:

`rails db:reset`

or it could be uploaded via the API:

`curl -XPOST 127.0.0.1:3000/api/import`

* How to run the test suite

rake

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
