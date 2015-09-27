defmodule ReverseProxy.Router do
  @moduledoc """
  A Plug for routing requests to either be serverd from cache
  or from a set of upstream servers.
  """

  use Plug.Router

  @default_used false

  plug :match
  plug :dispatch

  for {host, upstream} <- Application.get_env(ReverseProxy, :upstreams, []) do
    @upstream upstream
    if host == :_ do
      host = nil
      @default_used true
    end
    match _, host: host do
      match_internal(conn, @upstream)
    end
  end

  unless @default_used do
    match _, do: conn |> send_resp(400, "Bad Request")
  end

  def match_internal(conn, upstream) do
    callback = fn conn ->
      runner = Application.get_env(ReverseProxy, :runner, ReverseProxy.Runner)
      runner.retreive(conn, upstream)
    end

    if Application.get_env(ReverseProxy, :cache, false) do
      cacher = Application.get_env(ReverseProxy, :cacher, ReverseProxy.Cache)
      cacher.serve(conn, callback)
    else
      callback.(conn)
    end
  end
end
