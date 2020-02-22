FROM elixir:1.9-alpine

# install build dependencies
RUN apk add --update git build-base
RUN apk add --no-cache make gcc libc-dev

# prepare build dir
ENV HOME /app
RUN mkdir -p ${HOME}
WORKDIR ${HOME}

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN HEX_HTTP_CONCURRENCY=1 HEX_HTTP_TIMEOUT=360 mix deps.get
RUN mix deps.compile

# build project
COPY priv priv
COPY lib lib
RUN mix compile

# build release
COPY rel rel
RUN mix release

# prepare release image
FROM alpine:3 AS app
RUN apk add --update bash openssl
ENV HOME /app
ENV PORT=4000
EXPOSE 4000

RUN mkdir -p ${HOME}
WORKDIR ${HOME}

COPY --from=0 /app/_build/prod/rel/docker_stake_service ./
COPY boot.sh boot.sh
RUN chown -R nobody: /app
USER nobody

CMD ["/app/boot.sh"]
