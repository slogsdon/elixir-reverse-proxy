defmodule ReverseProxy.RouterTest do
  use ExUnit.Case
  use Plug.Test

  setup do
    Application.put_env(ReverseProxy, :cache, false)
    Application.put_env(ReverseProxy, :cacher, ReverseProxy.Cache)
  end

  test "request without a host" do
    conn = conn(:get, "/")

    conn = ReverseProxy.Router.call(conn, [])

    assert conn.status == 400
    assert conn.resp_body == "Bad Request"
  end

  test "request with unknown host" do
    conn = conn(:get, "/")
      |> Plug.Conn.put_req_header("host", "google.com")

    conn = ReverseProxy.Router.call(conn, [])

    assert conn.status == 400
    assert conn.resp_body == "Bad Request"
  end

  test "request with known host (domain)" do
    conn = conn(:get, "/")
      |> Map.put(:host, "example.com")

    conn = ReverseProxy.Router.call(conn, [])

    assert conn.status == 200
    assert conn.resp_body == "success"
  end

  test "request with known host (subdomain)" do
    conn = conn(:get, "/")
      |> Map.put(:host, "api.example.com")

    conn = ReverseProxy.Router.call(conn, [])

    assert conn.status == 200
    assert conn.resp_body == "success"
  end

  test "request with known host (subdomain only)" do
    conn = conn(:get, "/")
      |> Map.put(:host, "api.example2.com")

    conn = ReverseProxy.Router.call(conn, [])

    assert conn.status == 200
    assert conn.resp_body == "success"
  end

  test "request with known host (not responsive)" do
    conn = conn(:get, "/")
      |> Map.put(:host, "badgateway.com")

    conn = ReverseProxy.Router.call(conn, [])

    assert conn.status == 502
    assert conn.resp_body == "Bad Gateway"
  end

  test "request with known host from cache miss" do
    Application.put_env(ReverseProxy, :cache, true)
    conn = conn(:get, "/")
      |> Map.put(:host, "example.com")

    conn = ReverseProxy.Router.call(conn, [])

    assert conn.status == 200
    assert conn.resp_body == "success"
  end

  test "request with known host from cache hit" do
    Application.put_env(ReverseProxy, :cache, true)
    Application.put_env(ReverseProxy, :cacher, ReverseProxyTest.Cache)
    conn = conn(:get, "/")
      |> Map.put(:host, "example.com")

    conn = ReverseProxy.Router.call(conn, [])

    assert conn.status == 200
    assert conn.resp_body == "cached success"
  end
end
