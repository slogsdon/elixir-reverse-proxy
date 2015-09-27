defmodule ReverseProxyTest.FailurePlug do
  def init(opts), do: opts
  def call(conn, _) do
    conn |> Plug.Conn.resp(500, "failure")
  end
end
