defmodule ReverseProxy.RunnerTest do
  use ExUnit.Case
  use Plug.Test

  test "retreive/2 - plug - success" do
    conn = conn(:get, "/")

    conn = ReverseProxy.Runner.retreive(
      conn,
      {__MODULE__.SuccessPlug, []}
    )

    assert conn.status == 200
    assert conn.resp_body == "success"
  end

  test "retreive/2 - plug - failure" do
    conn = conn(:get, "/")

    conn = ReverseProxy.Runner.retreive(
      conn,
      {__MODULE__.FailurePlug, []}
    )

    assert conn.status == 500
    assert conn.resp_body == "failure"
  end

  test "retreive/3 - http - success" do
    conn = conn(:get, "/")

    conn = ReverseProxy.Runner.retreive(
      conn,
      ["localhost"],
      __MODULE__.SuccessHTTP
    )

    assert conn.status == 200
    assert conn.resp_body == "success"
  end

  test "retreive/3 - http - failure" do
    conn = conn(:get, "/")

    conn = ReverseProxy.Runner.retreive(
      conn,
      ["localhost"],
      __MODULE__.FailureHTTP
    )

    assert conn.status == 502
    assert conn.resp_body == "Bad Gateway"
  end

  # fixtures

  defmodule SuccessPlug do
    def init(opts), do: opts
    def call(conn, _) do
      conn |> Plug.Conn.resp(200, "success")
    end
  end
  defmodule FailurePlug do
    def init(opts), do: opts
    def call(conn, _) do
      conn |> Plug.Conn.resp(500, "failure")
    end
  end
  defmodule SuccessHTTP do
    def request(_method, _url, _body, _headers, _opts \\ []) do
      {:ok, %{:headers => [], :status_code => 200, :body => "success"}}
    end
  end
  defmodule FailureHTTP do
    def request(_method, _url, _body, _headers, _opts \\ []) do
      {:error, "failure"}
    end
  end
end
