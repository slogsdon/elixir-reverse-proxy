defmodule PlugUpstream.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    conn |> send_resp(200, "Hello, PlugUpstream")
  end

  match _ do
    conn |> send_resp(418, "i'm a teapot")
  end
end
