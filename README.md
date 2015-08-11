# ReverseProxy

A Plug based, reverse proxy server.

## Running

```elixir
plug_adapter = Plug.Adapters.Cowboy
options = []
adapter_options = []

plug_adapter.http ReverseProxy.Router, options, adapter_options
```

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

> Note: This feature has not yet been built.

```elixir
config ReverseProxy,
  # ...
  cache: false
```

## License

ReverseProxy is released under the MIT License.

See [LICENSE](https://github.com/slogsdon/elixir-reverse-proxy/blob/master/LICENSE) for details.
