defmodule PlugEtf do
  import Plug.Conn, only: [put_resp_content_type: 2, send_resp: 3]

  @doc "Send ETF response"
  @spec send_etf(Plug.Conn.t(), Plug.Conn.status(), Plug.Conn.body()) ::
          Plug.Conn.t() | no_return()
  def send_etf(conn, status, data) do
    conn
    |> put_resp_content_type("application/x-erlang-binary")
    |> send_resp(status, encode(data))
  end

  def encode(term), do: :erlang.term_to_binary(term)
  def decode(binary), do: :erlang.binary_to_term(binary)
end
