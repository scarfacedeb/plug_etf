defmodule PlugEtf.MixProject do
  use Mix.Project

  def project do
    [
      app: :plug_etf,
      version: "0.1.0",
      elixir: "~> 1.7",
      deps: deps()
    ]
  end

  def application, do: []

  defp deps do
    [
      {:plug, "~> 1.6"}
    ]
  end
end
