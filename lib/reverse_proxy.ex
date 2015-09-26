defmodule ReverseProxy do
  @moduledoc """
  A Plug based, reverse proxy server.

  `ReverseProxy` can act as a standalone service or as part of a plug
  pipeline in an existing application.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
    ]

    opts = [strategy: :one_for_one, name: ReverseProxy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
