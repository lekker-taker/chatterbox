FROM ruby:3.0.1-alpine as builder
LABEL org.opencontainers.image.source https://github.com/lekker-taker/chatterbox

RUN apk update && apk upgrade
RUN apk add --update alpine-sdk 
ENV APP_HOME /app
ENV RAILS_ENV=production
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/
RUN bundle install --deployment --jobs=4 --without development test
COPY . $APP_HOME

FROM ruby:3.0.1-alpine

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY --from=builder /app $APP_HOME
ENV RAILS_ENV=production
RUN bundle config --local path vendor/bundle
RUN bundle config --local without development:test:assets
EXPOSE 3001:3001
CMD bundle exec puma -e production -b tcp://0:3001 --pidfile /tmp/puma.pid

