defmodule ReverseProxy.RunnerTest do
  use ExUnit.Case
  use Plug.Test

  test "retreive/2 - plug - success" do
    conn = conn(:get, "/")

    conn = ReverseProxy.Runner.retreive(
      conn,
      {ReverseProxyTest.SuccessPlug, []}
    )

    assert conn.status == 200
    assert conn.resp_body == "success"
  end

  test "retreive/2 - plug - success with response headers" do
    conn = conn(:get, "/")
    headers = [
      {"cache-control", "max-age=0, private, must-revalidate"},
      {"x-header-1", "yes"},
      {"x-header-2", "yes"}
    ]

    conn = ReverseProxy.Runner.retreive(
      conn,
      {ReverseProxyTest.SuccessPlug, headers: headers}
    )

    assert conn.status == 200
    assert conn.resp_body == "success"
    assert conn.resp_headers == headers
  end

  test "retreive/2 - plug - failure" do
    conn = conn(:get, "/")

    conn = ReverseProxy.Runner.retreive(
      conn,
      {ReverseProxyTest.FailurePlug, []}
    )

    assert conn.status == 500
    assert conn.resp_body == "failure"
  end

  test "retreive/3 - http - success" do
    conn = conn(:get, "/")

    conn = ReverseProxy.Runner.retreive(
      conn,
      ["localhost"],
      ReverseProxyTest.SuccessHTTP
    )

    assert conn.status == 200
    assert conn.resp_body == "success"
  end

  test "retrieve/3 - partial body" do
    conn =
      conn(:post, "/", String.duplicate("_", 8_000_000 + 1))
      |> put_req_header("content-type", "application/json")
      |> ReverseProxy.Runner.retreive(
           ["localhost"],
           ReverseProxyTest.BodyLength
         )

    assert conn.resp_body == "8000001"
  end

  test "retrieve/3 - chunked response" do
    conn =
      conn(:get, "/")
      |> ReverseProxy.Runner.retreive(
           ["localhost"],
           ReverseProxyTest.ChunkedResponse
         )

    assert get_resp_header(conn, "transfer-encoding") == []
  end

  test "retreive/3 - http - success with response headers" do
    conn = conn(:get, "/")
    headers = ReverseProxyTest.SuccessHTTP.headers

    conn = ReverseProxy.Runner.retreive(
      conn,
      ["localhost"],
      ReverseProxyTest.SuccessHTTP
    )

    assert conn.status == 200
    assert conn.resp_body == "success"
    assert conn.resp_headers == headers
  end

  test "retreive/3 - http - location header rewrite" do
    conn = conn(:get, "/")
     |> put_req_header("host", "localhost:4000")

    conn = ReverseProxy.Runner.retreive(
      conn,
      ["localhost:5001"],
      ReverseProxyTest.RedirectHTTP
    )

    assert conn.status == 301
    assert conn.resp_body == """
    <html><body>You are being <a href="http://localhost:4000/foo">redirected</a>.</body></html>
    """
    assert conn.resp_headers == [
      {"cache-control", "max-age=0, private, must-revalidate"},
      {"location", "http://localhost:4000/foo"},
    ]
  end

  test "retreive/3 - http - failure" do
    conn = conn(:get, "/")

    conn = ReverseProxy.Runner.retreive(
      conn,
      ["localhost"],
      ReverseProxyTest.FailureHTTP
    )

    assert conn.status == 502
    assert conn.resp_body == "Bad Gateway"
  end
end
