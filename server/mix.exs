defmodule GoLinksEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :go_links,
      version: "0.1.0",
      elixir: "~> 1.14.0",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Server.App, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:amnesia, "~> 0.2.8"},
      {:jason, "~> 1.4.4"}
    ]
  end
end
