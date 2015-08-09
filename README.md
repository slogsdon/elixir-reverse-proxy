# ReverseProxy

A Plug based, reverse proxy server.

Upstream servers can be listed per-domain in the following forms:

- List of remote nodes, e.g. `["host:4000", "host:4001"]`
- A `{plug, options}` tuple, useful for umbrella applications

## License

ReverseProxy is released under the MIT License.

See [LICENSE](https://github.com/slogsdon/elixir-reverse-proxy/blob/master/LICENSE) for details.
