defmodule ReverseProxy.CacheTest do
  use ExUnit.Case
  use Plug.Test

  test "cache miss" do
    callback = fn conn ->
      conn |> Plug.Conn.send_resp(200, "success")
    end
    conn = conn(:get, "/")

    conn = ReverseProxy.Cache.serve(conn, callback)

    assert conn.status == 200
    assert conn.resp_body == "success"
  end
end
