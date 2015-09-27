use Mix.Config

config :dogma,
  rule_set: Dogma.RuleSet.All,
  exclude: [
    ~r(example/),
    ~r(test/)
  ]

config :reverse_proxy,
  upstreams: %{ "api." => {ReverseProxyTest.SuccessPlug, []},
                "example.com" => {ReverseProxyTest.SuccessPlug, []},
                "badgateway.com" => ["localhost:1"] }
