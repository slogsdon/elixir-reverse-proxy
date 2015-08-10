use Mix.Config

config :logger, :console,
  level: :info,
  format: "$date $time [$level] $metadata$message\n",
  metadata: [:user_id]

config ReverseProxy,
  cache: false,
  upstreams: %{ "api." => ["localhost:4000"],
                "slogsdon.com" => ["localhost:4001"] }
