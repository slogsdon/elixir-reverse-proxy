use Mix.Config

config :reverse_proxy,
  upstreams: %{ "api." => {ReverseProxyTest.SuccessPlug, []},
                "example.com" => {ReverseProxyTest.SuccessPlug, []},
                "badgateway.com" => ["localhost:1"] }
