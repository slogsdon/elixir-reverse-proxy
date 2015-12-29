defmodule ReverseProxy.Runner do
  @moduledoc """
  Retreives content from an upstream.
  """

  @typedoc "Representation of an upstream service."
  @type upstream :: [String.t] | {Atom.t, Keyword.t}

  @spec retreive(Plug.Conn.t, upstream) :: Plug.Conn.t
  def retreive(conn, upstream)
  def retreive(conn, {plug, opts}) when plug |> is_atom do
    options = plug.init(opts)
    plug.call(conn, options)
  end

  @spec retreive(Plug.Conn.t, upstream, Atom.t) :: Plug.Conn.t
  def retreive(conn, servers, client \\ HTTPoison) do
    server = upstream_select(servers)
    {method, url, body, headers} = prepare_request(server, conn)
    method
      |> client.request(url, body, headers, timeout: 5_000)
      |> process_response(conn)
  end

  @spec prepare_request(String.t, Plug.Conn.t) :: {Atom.t,
                                                  String.t,
                                                  String.t,
                                                  [{String.t,String.t}]}
  defp prepare_request(server, conn) do
    conn = conn
            |> Plug.Conn.put_req_header(
              "x-forwarded-for",
              conn.remote_ip |> ip_to_string
            )
    method = conn.method |> String.downcase |> String.to_atom
    url = "#{conn.scheme}://#{server}#{conn.request_path}?#{conn.query_string}"
    headers = conn.req_headers |> Enum.map fn {k, v} -> {k |> String.capitalize, v} end
    body = conn.body_params |> Plug.Conn.Query.encode

    {method, url, body, headers}
  end

  @spec process_response({Atom.t, Map.t}, Plug.Conn.t) :: Plug.Conn.t
  defp process_response({:error, _}, conn) do
    conn |> Plug.Conn.send_resp(502, "Bad Gateway")
  end
  defp process_response({:ok, response}, conn) do
    conn
      |> put_resp_headers(response.headers)
      |> Plug.Conn.send_resp(response.status_code, response.body)
  end

  @spec put_resp_headers(Plug.Conn.t, [{String.t, String.t}]) :: Plug.Conn.t
  defp put_resp_headers(conn, []), do: conn
  defp put_resp_headers(conn, [{header, value}|rest]) do
    conn
      |> Plug.Conn.put_resp_header(header |> String.downcase, value)
      |> put_resp_headers(rest)
  end

  defp ip_to_string({a,b,c,d}), do: "#{a}.#{b}.#{c}.#{d}"

  defp upstream_select(servers) do
    servers |> hd
  end
end
