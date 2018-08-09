# PlugEtf

This library adds support of Erlang Text Format (ETF) requests and responses to Plug.

In short, it uses `:erlang.term_to_binary/1` and `:erlang.binary_to_term/1` to encode/decode params.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `plug_etf` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:plug_etf, "~> 0.1.0"}
  ]
end
```

## Usage

Add Plug.Parsers.ETF plug to parse ETF request params:

```
plug Plug.Parsers,
  parsers: [:etf],
  pass: ["application/x-erlang-binary"]
```

To send ETF body responses:

```
import PlugEtf

get "/" do
  send_etf(conn, 200, %{"data" => 1})
end
```

> Do not use it in unsafe environments, when you don't control client side.
> Calling :erlang.binary_to_term() with atoms may lead to vm crashes.
