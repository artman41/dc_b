# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :coxir, [
    token: "MzUyMDA2MjEwNjAzNDUwMzY4.DtNeng.IQlXJoT_O6NDFTmoJ9lWMUd4Tek"
]


config :logger, :console, [
    application: :discord,
    format: "\n[$time $level]\nMetadata: $metadata\n--\nMessage: $message\n--\n",
    metadata: [:event_type, :username, :user_id, :channel_id, :type, :tts]
]
