defmodule PlugEtf.MixProject do
  use Mix.Project

  def project do
    [
      app: :plug_etf,
      version: "0.1.0",
      elixir: "~> 1.7",
      description: "Add support of ETF requests and responses to Plug",
      deps: deps(),
      package: package()
    ]
  end

  def application, do: []

  defp deps do
    [
      {:plug, "~> 1.6"},
      {:ex_doc, "~> 0.19", only: :dev}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      maintainers: ["Andrew Volozhanin"],
      links: %{"Github" => "https://github.com/scarfacedeb/plug_etf"}
    ]
  end
end
