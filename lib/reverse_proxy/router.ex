defmodule ReverseProxy.Router do
  @moduledoc """
  A Plug for routing requests to either be served from cache
  or from a set of upstream servers.
  """

  use Plug.Router

  @default_used false

  plug :match
  plug :dispatch

  for {host, upstream} <- Application.get_env(:reverse_proxy, :upstreams, []) do
    @upstream upstream
    host =
      if host == :_ do
        @default_used true
        nil
      else
        host
      end
    match _, host: host do
      ReverseProxy.call(conn, upstream: @upstream)
    end
  end

  unless @default_used do
    match _, do: conn |> send_resp(400, "Bad Request")
  end
end
