#!/bin/sh

export REDIS_URL="redis://${REDIS_PORT_6379_TCP_ADDR}:${REDIS_PORT_6379_TCP_PORT}"
bundle exec sidekiq --daemon --config config/sidekiq.yml
exec "$@"
