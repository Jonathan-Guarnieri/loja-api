FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /loja-api

WORKDIR /loja-api

ADD Gemfile /loja-api/Gemfile

ADD Gemfile.lock /loja-api/Gemfile.lock

RUN gem install bundler

RUN bundle install

ADD . /loja-api
