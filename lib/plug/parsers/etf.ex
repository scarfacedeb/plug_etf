defmodule Plug.Parsers.ETF do
  @moduledoc """
  Parses Erlang Term Format request body.

  Uses built-in `:erlang.binary_to_term`.

  Any data that isn't a map is parsed into a `"_etf"` key to allow
  proper param merging.

  An empty request body is parsed as an empty map.
  """

  @behaviour Plug.Parsers

  def init(opts) do
    opts = Keyword.put_new(opts, :length, 1_000_000)
    Keyword.pop(opts, :body_reader, {Plug.Conn, :read_body, []})
  end

  def parse(conn, "application", "x-erlang-binary", _headers, {{mod, fun, args}, opts}) do
    case apply(mod, fun, [conn, opts | args]) do
      {:ok, body, conn} ->
        {:ok, decode(body), conn}

      {:more, _data, conn} ->
        {:error, :too_large, conn}

      {:error, :timeout} ->
        raise Plug.TimeoutError

      {:error, _} ->
        raise Plug.BadRequestError
    end
  end

  def parse(conn, _type, _subtype, _headers, _opts) do
    {:next, conn}
  end

  defp decode(body) do
    case PlugEtf.decode(body) do
      nil ->
        %{}

      terms when is_map(terms) ->
        terms

      terms ->
        %{"_etf" => terms}
    end
  rescue
    e ->
      reraise Plug.Parsers.ParseError, [exception: e], __STACKTRACE__
  end
end
