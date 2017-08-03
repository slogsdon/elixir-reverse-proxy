defmodule ReverseProxyTest.Body do
  def request(_method, _url, body, _headers, _opts \\ []) do
    {:ok, %{
      :headers => [],
      :status_code => 200,
      :body => body
    }}
  end
end
