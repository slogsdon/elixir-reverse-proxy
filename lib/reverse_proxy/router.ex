defmodule ReverseProxy.Router do
  @moduledoc """
  A Plug for routing requests to either be serverd from cache
  or from a set of upstream servers.
  """

  use Plug.Router

  plug :match
  plug :dispatch

  for {host, servers} <- Application.get_env(ReverseProxy, :upstreams, []) do
    @servers servers
    match _, host: host do
      upstream = fn conn ->
        ReverseProxy.Runner.retreive(conn, @servers)
      end

      if Application.get_env(ReverseProxy, :cache, false) do
        ReverseProxy.Cache.serve(conn, upstream)
      else
        upstream.(conn)
      end
    end
  end

  match _, do: conn |> send_resp(400, "")
end
