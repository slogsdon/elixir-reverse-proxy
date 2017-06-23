defmodule ReverseProxyTest.RedirectHTTP do
  def request(_method, _url, _body, _headers, _opts \\ []) do
    {:ok, %{
      headers: headers,
      status_code: 301,
      body: """
      <html><body>You are being <a href="http://localhost:5001/foo">redirected</a>.</body></html>
      """
    }}
  end
  def headers do
    [
      {"cache-control", "max-age=0, private, must-revalidate"},
      {"Location", "http://localhost:5001/foo"},
    ]
  end
end
