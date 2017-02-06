defmodule ReverseProxyTest.BodyLength do
  def request(_method, _url, body, _headers, _opts \\ []) do
    body_length = case body do
      {:stream, body} ->
        body
        |> Enum.join("")
        |> byte_size
      body ->
        body
        |> byte_size
    end

    {:ok, %{
      :headers => [],
      :status_code => 200,
      :body => "#{body_length}"
    }}
  end
end
