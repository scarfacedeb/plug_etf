defmodule PlugEtfTest do
  use ExUnit.Case, async: true
  use Plug.Test

  describe "send_etf/3" do
    def gen_conn do
      PlugEtf.send_etf(conn(:post, "/"), 200, %{data: 1})
    end

    test "sets content type header" do
      conn = gen_conn()
      {_key, content_type} = List.keyfind(conn.resp_headers, "content-type", 0)
      assert content_type == "application/x-erlang-binary; charset=utf-8"
    end

    test "sends response with encoded body" do
      conn = gen_conn()
      assert :erlang.binary_to_term(conn.resp_body) == %{data: 1}
    end
  end
end
