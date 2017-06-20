use Mix.Config

config(:reverse_proxy,
       upstreams: %{
         # You could add foobar.localhost to /etc/hosts to test this
         "foobar.localhost" => ["http://www.example.com"],
         "api." => {ReverseProxyTest.SuccessPlug, []},
         "example.com" => {ReverseProxyTest.SuccessPlug, []},
         "badgateway.com" => ["http://localhost:1"] })
