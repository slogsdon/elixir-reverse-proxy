use Mix.Config

config :logger, :console,
  level: :info,
  format: "$date $time [$level] $metadata$message\n",
  metadata: [:user_id]

config ReverseProxy,
  upstreams: %{
    "example.com" => {PlugUpstream.Router, []}
  }
