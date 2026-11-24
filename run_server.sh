#!/bin/sh
mix do deps.get, deps.compile
mix ecto.create
mix phx.server
