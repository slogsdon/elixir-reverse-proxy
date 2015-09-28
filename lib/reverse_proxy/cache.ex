defmodule ReverseProxy.Cache do
  @moduledoc """
  A basic caching layer for `ReverseProxy`.

  Upstream content servers may be slow. SSL/TLS
  negotiation may be slow. Caching a response from the
  upstream increases the potential performance of
  `ReverseProxy`.
  """

  @typedoc "Callback to retreive an upstream response"
  @type callback :: (Plug.Conn.t -> Plug.Conn.t)

  @doc """
  Entrypoint to serve content from the cache when available
  (cache hit) and from the upstream when not available
  (cache miss).
  """
  @spec serve(Plug.Conn.t, callback) :: Plug.Conn.t
  def serve(conn, upstream) do
    upstream.(conn)
  end
end
