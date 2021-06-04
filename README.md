
# Chatterbox

 Backend repository for chatterbox app.
 A unified customer experience analytics platform enabling companies to  examine feedback at scale. 

**WARNING**
This app is not production ready yet.
Please refer to [Limitations](#Limitations) and [TODO](#todo) sections for unresolved issues.

### API
Chatterbox app provides 4 API endpoints:

GET **/api/swagger_doc.json** -- OpenAPI v3 API schema.

GET **/api/v1/dashboard.json** -- Provides aggregated sentiment data with theme\category breakdown.

GET **/api/v1/themes.json** -- Full list of valid theme and category names.

POST **/api/v1/reviews** -- Accepts `reviews.json` file. (Re)populates DB.

*CORS allows access from https://editor.swagger.io (strongly recommended!)*

 
### App structure
Main parts of app are:
* Grape API definitions in **app/controllers/api**
* In-memory themes model in **app/models**
* Service objects in **app/services**

*As it's not a real app yet so for simplicity there's no background processing and RDBMS storage.*
  
### Database creation \ initialization
Sample data contained in repo at /db/data.
Themes & categories are loaded on app boot to AR like `Theme` class. And persisted in class variables.
Reviews data persisted in `Elastic`. It could be populated either via rake task:

`rails db:reset`

or uploaded via the API:

`curl -F 'reviews=@./db/data/reviews.json' http://185-3-92-120.nip.io/api/review`

### Deployment instructions
The app contains HELM3 chart to deploy app, nginx and elastic to k8s cluster.
It should be possible to deploy to singlenode like minikube or docker-desktop k8s.
But default configuration is optimized for 3 node cluser.
  
Before deploy make sure you have `kubectl` and `helm` V3 installed. And your k8s cluster is ready.

```bash
# Verify KUBECONFIG is OK. And cluster is reachable.
kubectl cluster-info
 
# Installs nginx-ingress, elastic and app into default context
cd ./helm
make install --wait

# Wait few minutes for elastic to start 3 nodes
make getaddr # Prints swagger doc URL
```

### Development notes
As CI\CD is not implemented, deploying changes requires rebuild of the docker image:
```
docker buildx build -t ghcr.io/lekker-taker/chatterbox:latest --platform linux/amd64 --push .
```

### Tests
Unfortunatly testsuite only includes some integration test done as rspec request specs.
Following testing honeycomb principle to have biggest bang for buck.
There are few rough edges in app that would benefit from future unit tests. Test coverage is not being measured.
  
Running tests:
```
# Following variables already set as defaults. Affect data storage
echo 'ELASTICSEARCH_URL=http://elastic:9200' >>.env.test.local
echo 'REVIEWS_INDEX_NAME=reviews_test' >>.env.test.local

# Populate test:db
env RAILS_ENV=test rails db:reset

# Run specs
bundle exec rspec
```

### Limitations
Please note the default deployment configuration creates 3 node Elastic cluster with tiny nodes.
Application's k8s deployment is not constrained in resources provided.
During the import it might consume ~10x of imported `reviews.json`
Nginx Ingress has file limit set to 20MB so App should not consume over ~200MB.
Ingress will timeout after 60sec.
  
Considering this limitations import of over 100k reviews expected to fail.

### TODO
Missing critical parts to be resolved before app could be considered production grade:
* **Authentication**
All endpoints lack authentication ana authorization.
* **Sidekiq**
Synchronous processing of import is slow and unrealiable
* **CI\CD**
* **RDBMS**
  Theme\category data should be persisted via ActiveRecord
* **Tests**
  Unit tests and serivces test are needed

