defmodule ReverseProxyTest.SuccessHTTP do
  def request(_method, _url, _body, _headers, _opts \\ []) do
    {:ok, %{
      :headers => headers(),
      :status_code => 200,
      :body => "success"
    }}
  end
  def headers do
    [
      {"cache-control", "max-age=0, private, must-revalidate"},
      {"x-header-1", "yes"},
      {"x-header-2", "yes"}
    ]
  end
end
