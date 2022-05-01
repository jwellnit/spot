# base image
ARG RUBY_VERSION=2.4.6-alpine3.10
FROM ruby:$RUBY_VERSION as spot-base

# system dependencies
# TODO: imagemagick might belong in the worker container instead?
RUN apk --no-cache upgrade && \
    apk --no-cache add \
        build-base \
        coreutils \
        curl \
        git \
        imagemagick \
        netcat-openbsd \
        nodejs \
        openssl \
        postgresql postgresql-dev \
        ruby-dev \
        tzdata \
        yarn \
        zip

# let's not run this as root
# (taken from hyrax's Dockerfile)
# RUN addgroup -S -g 101 app && \
#     adduser -S -G app -u 1001 -s /bin/sh -h /app app
# RUN mkdir /spot && chown -R 1001:101 /spot
# USER app

WORKDIR /spot

# match our Gemfile.lock version
# TODO: upgrade the Gemfile bundler version to 2
RUN gem install bundler:1.13.7

# install dependencies
# ---
# get installation files copied over first, run installations, _then_ copy
# the application files over, so that we can rely on docker's cache first
# when rebuilding.
#
# a) bundle + yarn files
# COPY --chown=1001:101 ["Gemfile", "Gemfile.lock", "package.json", "yarn.lock", "/spot"]
COPY ["Gemfile", "Gemfile.lock", "package.json", "yarn.lock", "/spot"]

# b) make directories for installation configuration (`config/`, `public/`, and `vendor/`)
#    and those for derivatives + uploads
RUN mkdir -p /spot/config /spot/public && \
    mkdir -p /spot/derivatives /spot/uploads

# c) install dependencies
RUN bundle config set --local without "development test" && \
    bundle install --jobs "$(nproc)"

# d) copy the application files
# COPY --chown=1001:101 . /spot
COPY . /spot

ENTRYPOINT ["/spot/bin/spot-entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "tcp://0.0.0.0:3000"]

FROM spot-base as spot-app-dev

COPY config/uv config/uv

# run yarn install first so we don't need to always rerun when updating gems
RUN yarn install

RUN bundle config unset --local without && \
    bundle config set --local with "development test" && \
    bundle install --jobs "$(nproc)"

CMD ["bundle", "exec", "rails", "server", "-u", "puma", "-b", "ssl://0.0.0.0:443?key=/trustee_minutes/tmp/ssl/application.key&cert=/trustee_minutes/tmp/ssl/application.crt"]

# precompile assets
# RUN DATABASE_URL="postgres://fake" SECRET_KEY_BASE="secret-shh" bundle exec rake assets:precompile

FROM spot-base as spot-worker-dev
# USER root
RUN apk --no-cache upgrade && \
    apk --no-cache add \
        imagemagick \
        ghostscript

# USER app
RUN bundle config unset --local without && \
    bundle install --jobs "$(nproc)"

CMD ["bundle", "exec", "sidekiq"]
