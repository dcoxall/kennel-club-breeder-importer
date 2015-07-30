FROM ruby:2.2

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/

VOLUME ["/usr/src/app"]

RUN apt-get update \
  && apt-get install -y postgresql-client --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D

RUN bundle install

EXPOSE 3000
ENTRYPOINT ["/usr/src/app/bin/startup.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
