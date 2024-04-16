# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /app

# Set production environment
ENV RAILS_ENV="production"


# Throw-away build stage to reduce size of final image
FROM base as build_dev_image

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl git libvips node-gyp pkg-config python-is-python3

# Install JavaScript dependencies
ARG NODE_VERSION=20.11.1
ARG YARN_VERSION=1.22.22
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

#------------------------------------------------------------
# IMMAGINE DI SVILUPPO
FROM build_dev_image as development_image

ARG default_editor
RUN apt-get install -y nano gpg gpg-agent git-lfs git
#questo serve per editare le credentials
ENV EDITOR='nano' \
    BUNDLE_PATH="/bundle"
# helper per webpacker
RUN touch /.yarnrc && chmod 777  /.yarnrc
RUN mkdir /.cache && chmod 777 /.cache
RUN adduser --system -D --uid 1000  -h /home/nobody  --shell /bin/bash rails rails


RUN mkdir /bundle && chmod -R ugo+rwt /bundle
VOLUME /bundle

RUN gem install foreman
##
# Installiamo:
# bundle-audit  : gemma per controllo di sicurezza https://github.com/rubysec/bundler-audit
# bummr         : gemma per upgrade automatizzato delle gemme con singoli commit per gemma
RUN gem install bundle-audit bummr

RUN mkdir -p /home/nobody && chmod 777 /home/nobody
ENV HOME="/home/nobody"

