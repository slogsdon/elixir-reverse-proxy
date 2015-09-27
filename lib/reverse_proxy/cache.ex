defmodule ReverseProxy.Cache do
  @moduledoc """
  A basic caching layer for `ReverseProxy`.
  """

  @typedoc "Callback to retreive an upstream response"
  @type callback :: (Plug.Conn.t -> Plug.Conn.t)

  @spec serve(Plug.Conn.t, callback) :: Plug.Conn.t
  def serve(conn, upstream) do
    upstream.(conn)
  end
end
