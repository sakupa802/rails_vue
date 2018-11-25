FROM ruby:2.5.1-alpine3.7

ENV LANG=C.UTF-8 \
    APP_ROOT=/app \
    BUNDLE_PATH=/bundle \
    BUNDLE_FORCE_RUBY_PLATFORM=1

RUN apk update && apk upgrade && apk add --no-cache nodejs mysql-dev mysql-client libxml2 libxslt imagemagick openssh sqlite git curl-dev && npm install -g yarn
RUN apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    echo Asia/Tokyo > /etc/timezone && \
    rm -rf /var/cache/apk/*

RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT

# rails install
ADD Gemfile $APP_ROOT/Gemfile
ADD Gemfile.lock $APP_ROOT/Gemfile.lock
RUN apk add --no-cache --virtual .ruby-builddeps alpine-sdk linux-headers libxml2-dev libxslt-dev imagemagick-dev sqlite-dev \
 && bundle install -j4

# yarn install
ADD package.json $APP_ROOT/package.json
ADD yarn.lock $APP_ROOT/yarn.lock
RUN yarn install

ADD . $APP_ROOT
