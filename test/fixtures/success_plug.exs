defmodule ReverseProxyTest.SuccessPlug do
  def init(opts), do: opts
  def call(conn, opts) do
    opts = opts |> Keyword.put_new(:headers, [])
    conn
      |> put_resp_headers(opts[:headers])
      |> Plug.Conn.resp(200, "success")
  end
  defp put_resp_headers(conn, headers) do
    headers
      |> Enum.reduce(conn, fn {h, v}, c ->
        c |> Plug.Conn.put_resp_header(h, v)
      end)
  end
end
