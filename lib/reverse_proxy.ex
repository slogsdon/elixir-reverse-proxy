defmodule ReverseProxy do
  @moduledoc """
  A Plug based, reverse proxy server.

  `ReverseProxy` can act as a standalone service or as part of a plug
  pipeline in an existing application.

  From [Wikipedia](https://wikipedia.org/wiki/Reverse_proxy):

  > In computer networks, a reverse proxy is a type of proxy server
  > that retrieves resources on behalf of a client from one or more
  > servers. These resources are then returned to the client as
  > though they originated from the proxy server itself. While a
  > forward proxy acts as an intermediary for its associated clients
  > to contact any server, a reverse proxy acts as an intermediary
  > for its associated servers to be contacted by any client.
  """

  use Application
  @behaviour Plug

  @spec init(Keyword.t) :: Keyword.t
  def init(opts), do: opts

  @spec call(Plug.Conn.t, Keyword.t) :: Plug.Conn.t
  def call(conn, opts) do
    upstream = Keyword.get(opts, :upstream, [])
    callback = fn conn ->
      runner = Application.get_env(:reverse_proxy, :runner, ReverseProxy.Runner)
      runner.retreive(conn, upstream)
    end

    if Application.get_env(:reverse_proxy, :cache, false) do
      cacher = Application.get_env(:reverse_proxy, :cacher, ReverseProxy.Cache)
      cacher.serve(conn, callback)
    else
      callback.(conn)
    end
  end

  @spec start(term, term) :: {:error, term}
                           | {:ok, pid}
                           | {:ok, pid, term}
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
    ]

    opts = [strategy: :one_for_one, name: ReverseProxy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
