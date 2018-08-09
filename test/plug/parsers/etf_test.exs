defmodule Plug.Parsers.ETFTest do
  use ExUnit.Case, async: true
  use Plug.Test

  def etf_conn(body) do
    put_req_header(conn(:post, "/", body), "content-type", "application/x-erlang-binary")
  end

  def encode(term), do: :erlang.term_to_binary(term)

  def parse(conn, opts \\ []) do
    opts = opts |> Keyword.put_new(:parsers, [:etf])
    Plug.Parsers.call(conn, Plug.Parsers.init(opts))
  end

  test "parses the request body" do
    conn = %{"id" => 1} |> encode() |> etf_conn() |> parse()
    assert conn.params["id"] == 1
  end

  test "parses the request body when it is an array" do
    conn = [1, 2, 3] |> encode() |> etf_conn() |> parse()
    assert conn.params["_etf"] == [1, 2, 3]
  end

  test "handles empty body as blank map" do
    conn = nil |> encode() |> etf_conn() |> parse()
    assert conn.params == %{}
  end

  test "raises on too large bodies" do
    exception =
      assert_raise Plug.Parsers.RequestTooLargeError, fn ->
        %{too_large: "data"} |> encode() |> etf_conn() |> parse(length: 5)
      end

    assert Plug.Exception.status(exception) == 413
  end

  test "raises ParseError with malformed binary" do
    message =
      ~s(malformed request, a ArgumentError exception was raised with message "argument error")

    exception =
      assert_raise Plug.Parsers.ParseError, message, fn ->
        "Forgot to encode" |> etf_conn() |> parse()
      end

    assert Plug.Exception.status(exception) == 400
  end
end
