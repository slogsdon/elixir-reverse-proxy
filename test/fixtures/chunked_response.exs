defmodule ReverseProxyTest.ChunkedResponse do
  def request(_method, _url, _body, _headers, _opts \\ []) do
    {:ok, %{
      :headers => [{"transfer-encoding", "chunked"}],
      :status_code => 200,
      :body => ""
    }}
  end
end
