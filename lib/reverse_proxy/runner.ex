defmodule ReverseProxy.Runner do
  @moduledoc """
  Retreives content from an upstream.
  """

  alias Plug.Conn

  @typedoc "Representation of an upstream service."
  @type upstream :: [String.t] | {Atom.t, Keyword.t}

  @spec retreive(Conn.t, upstream) :: Conn.t
  def retreive(conn, upstream)
  def retreive(conn, {plug, opts}) when plug |> is_atom do
    options = plug.init(opts)
    plug.call(conn, options)
  end

  @spec retreive(Conn.t, upstream, Atom.t) :: Conn.t
  def retreive(conn, servers, client \\ HTTPoison) do
    server = upstream_select(servers)
    {method, url, body, headers} = prepare_request(server, conn)

    method
      |> client.request(url, body, headers, timeout: 5_000)
      |> process_response(conn, server)
  end

  @spec prepare_request(String.t, Conn.t) :: {Atom.t,
                                                  String.t,
                                                  String.t,
                                                  [{String.t, String.t}]}
  defp prepare_request(server, conn) do
    conn = conn
            |> Conn.put_req_header(
              "x-forwarded-for",
              conn.remote_ip |> ip_to_string
            )
            |> Conn.delete_req_header(
              "transfer-encoding"
            )
    method = conn.method |> String.downcase |> String.to_atom
    url = "#{conn.scheme}://#{server}#{conn.request_path}?#{conn.query_string}"
    headers = conn.req_headers
    body = case Conn.read_body(conn) do
      {:ok, body, _conn} ->
        body
      {:more, body, conn} ->
        {:stream,
          Stream.resource(
            fn -> {body, conn} end,
            fn
              {body, conn} ->
                {[body], conn}
              nil ->
                {:halt, nil}
              conn ->
                case Conn.read_body(conn) do
                  {:ok, body, _conn} ->
                    {[body], nil}
                  {:more, body, conn} ->
                    {[body], conn}
                end
            end,
            fn _ -> nil end
          )
        }
    end

    {method, url, body, headers}
  end

  @spec process_response({Atom.t, Map.t}, Plug.Conn.t, String.t) :: Plug.Conn.t
  defp process_response({:error, _}, conn, _server) do
    conn |> Plug.Conn.send_resp(502, "Bad Gateway")
  end
  defp process_response({:ok, response}, conn, server) do
    conn = conn |> put_resp_headers(response.headers)

    conn
      |> Plug.Conn.send_resp(response.status_code, response.body |> process_body(conn, server))
  end

  @spec put_resp_headers(Conn.t, [{String.t, String.t}]) :: Conn.t
  defp put_resp_headers(conn, []), do: conn
  defp put_resp_headers(conn, [{header = "Location", value}|rest]) do
    [host, port] = conn |> get_host() |> String.split(":")
    value = URI.parse(value)
          |> Map.put(:host, host)
          |> Map.put(:port, port |> String.to_integer)
          |> URI.to_string

    conn
      |> Plug.Conn.put_resp_header(header |> String.downcase, value)
      |> put_resp_headers(rest)
  end
  defp put_resp_headers(conn, [{header, value}|rest]) do
    conn
      |> Conn.put_resp_header(header |> String.downcase, value)
      |> put_resp_headers(rest)
  end

  defp ip_to_string({a, b, c, d}), do: "#{a}.#{b}.#{c}.#{d}"

  defp upstream_select(servers) do
    servers |> hd
  end

  defp process_body(body, conn, server) do
    body |> String.replace(server, conn |> get_host())
  end

  defp get_host(conn) do
    case conn |> Plug.Conn.get_req_header("host") do
      [head | _] -> head
      _ -> ""
    end
  end
end
