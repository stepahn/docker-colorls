ARG RUBY_VERSION=2.6.3-alpine

FROM ruby:${RUBY_VERSION} AS build
RUN apk add --update \
  build-base \
  ruby-dev

ARG VERSION=1.2.0
RUN gem install colorls -v ${VERSION}

RUN rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete

FROM ruby:${RUBY_VERSION}

RUN apk add --update \
  git

LABEL io.whalebrew.name 'colorls'
LABEL io.whalebrew.config.working_dir '/workdir'
WORKDIR /workdir

COPY --from=build /usr/local/bundle /usr/local/bundle

ENTRYPOINT ["colorls"]
