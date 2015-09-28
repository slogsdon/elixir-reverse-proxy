# ReverseProxy
[![Build Status](https://travis-ci.org/slogsdon/elixir-reverse-proxy.svg?branch=master)](https://travis-ci.org/slogsdon/elixir-reverse-proxy)
[![Coverage Status](https://coveralls.io/repos/slogsdon/elixir-reverse-proxy/badge.svg?branch=master&service=github)](https://coveralls.io/github/slogsdon/elixir-reverse-proxy?branch=master)

A Plug based, reverse proxy server.

`ReverseProxy` can act as a standalone service or as part of a plug pipeline in an existing application.

From [Wikipedia](https://wikipedia.org/wiki/Reverse_proxy):

> In computer networks, a reverse proxy is a type of proxy server that retrieves resources on behalf of a client from one or more servers. These resources are then returned to the client as though they originated from the proxy server itself. While a forward proxy acts as an intermediary for its associated clients to contact any server, a reverse proxy acts as an intermediary for its associated servers to be contacted by any client.

## Goals

- Domain based proxying
- Path based proxying
- Proxy cache
- SSL/TLS termination

## Non-goals

- Replace production reverse proxy solutions

## Configuration

### `:upstreams`

Upstream servers can be listed per-domain in the following forms:

- List of remote nodes, e.g. `["host:4000", "host:4001"]`
- A `{plug, options}` tuple, useful for umbrella applications

> Note: This structure may change in the future as the project progresses.

```elixir
config :reverse_proxy,
  # ...
  upstreams: %{ "api." => ["localhost:4000"],
                "slogsdon.com" => ["localhost:4001"] }
```

### `:cache`

Enables the caching of the responses from the upstream server.

> Note: This feature has not yet been built to completion. The current implementation treats all requests as hit misses.

```elixir
config :reverse_proxy,
  # ...
  cache: false
```

## Running

```elixir
plug_adapter = Plug.Adapters.Cowboy
options = []
adapter_options = []

plug_adapter.http ReverseProxy.Router, options, adapter_options
```

## Embedding

`ReverseProxy` can be embedded into an existing Plug application to proxy requests to required resources in cases where CORS or JSONP are unavailable.

> Note: This feature has not been thoroughly flushed out, so it might not yet act as described.

The following code leverages `Plug.Router.forward/2` to pass requests to the `/google` path to `ReverseProxy`:

```elixir
defmodule PlugReverseProxy.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  forward "/google", to: ReverseProxy, upstream: ["google.com"]
end
```

## License

ReverseProxy is released under the MIT License.

See [LICENSE](https://github.com/slogsdon/elixir-reverse-proxy/blob/master/LICENSE) for details.
