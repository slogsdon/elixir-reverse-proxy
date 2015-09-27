defmodule ReverseProxyTest.Cache do
  def serve(conn, upstream) do
    upstream.(conn)
      |> Map.update!(:resp_body, fn b ->
        "cached #{b}"
      end)
  end
end
