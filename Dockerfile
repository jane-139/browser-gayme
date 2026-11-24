FROM elixir:1.19.6-alpine
WORKDIR /app
RUN apk add inotify-tools
RUN mix local.hex --force
CMD ["./run_server.sh"]
