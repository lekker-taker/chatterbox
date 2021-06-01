# README

WARNING This app is not production ready. WARNING
Please refer to TODO section for unresolved issues. 

# API

Chatterbox app provides 4 API endpoints:

GET /api/swagger_doc.json  -- OpenAPI v3 API schema.
GET /api/dashboard.json -- Provides aggregated sentiment data with theme\category breakdown.
GET /api/themes.json -- Provides full list of valid theme and category names.
POST /api/reviews  -- Accepts new `reviews.json` file. Populates DB.

CORS allows access from https://editor.swagger.io (strongly recommended!)

* App structure

Main parts of app are:

Grape API definition in app/controllers/api
Single Model in app/models
Service objects in app/services

As it's not a real app for simplicity there's no background processing and RDBMS storage. Theme & category 


* Deployment instructions

The app contains HELM3 chart to deploy itself and dependencies to k8s cluster.
It should be possible to deploy to minikube or docker-desktop k8s. 

In order to deploy make sure you have `kubectl` and `helm` V3 installed.

```bash
# Verify KUBECONFIG is OK. And cluster is reachable.  
kubectl cluster info

cd ./helm

# Installs nginx-ingress, elastic and app into default context
make install --wait 
# Wait few minutes for elastic to start 3 nodes

make getaddr # Prints swagger doc URL
```

* Database creation \ initialization

Sample data contained in repo at /db/data.
Themes & categories are loaded on app boot to AR like `Theme` class. And persisted in class variables.

Reviews data persisted in `Elastic`. It could be populated  either from same sample set via rake task:

`rails db:reset`

or it could be uploaded via the API:

`curl -XPOST 127.0.0.1:3000/api/import`

Be aware current import stores each review via separate HTTP call, instead of using bulk import. It's quite slow. Also it's unfortunately synchronous.

* How to run the test suite

`bundle exec rspec`

# Develop

While CI\CD is not implemented, if making changes please rebuild the docker image manually:

```
docker buildx build -t ghcr.io/lekker-taker/chatterbox:latest --platform linux/amd64 --push  .
```

# TODO

This sections highlights few aspects to be resolved to make it production grade.

* Authentication
All endpoints lack authentication ana authorization. 

* Helm chart
Charts deploys 3 ES nodes and 2 puma workers w/o taking cluster hardware into consideration. It's quite inefficient. Utilization might be quite.

* Tests

Test are implemented to have biggest bang for bug aka Testing Honeycomb.
There are few rough edges in app that would benefit from future unit tests.
Also test coverage is not measured.

* CI\CD

No CI\CD for now.
