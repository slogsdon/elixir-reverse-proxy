# ReverseProxy

A Plug based, reverse proxy server.

## Configuration

### `:upstreams`

Upstream servers can be listed per-domain in the following forms:

- List of remote nodes, e.g. `["host:4000", "host:4001"]`
- A `{plug, options}` tuple, useful for umbrella applications

> Note: This structure may change in the future as the project progresses.

```elixir
config ReverseProxy,
  # ...
  upstreams: %{ "api." => ["localhost:4000"],
                "slogsdon.com" => ["localhost:4001"] }
```

### `:cache`

Enables the caching of the responses from the upstream server.

> Note: This feature has not yet been built to completion. The current implementation treats all requests as hit misses.

```elixir
config ReverseProxy,
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

  forward "/google", to: ReverseProxy.Router
end
```

and the accompanying configuration:

```elixir
config ReverseProxy,
  upstreams: %{
    "/google" => ["google.com"]
  }
```

## License

ReverseProxy is released under the MIT License.

See [LICENSE](https://github.com/slogsdon/elixir-reverse-proxy/blob/master/LICENSE) for details.
