defmodule ReverseProxyTest.FailureHTTP do
  def request(_method, _url, _body, _headers, _opts \\ []) do
    {:error, "failure"}
  end
end
