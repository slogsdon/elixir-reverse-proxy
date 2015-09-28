defmodule ReverseProxy.Mixfile do
  use Mix.Project

  def project do
    [app: :reverse_proxy,
     version: "0.1.0",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     name: "ReverseProxy",
     description: description,
     package: package,
     docs: [readme: "README.md", main: "README"],
     test_coverage: [tool: ExCoveralls]]
  end

  def application do
    [applications: [:logger, :plug, :cowboy, :httpoison],
     mod: {ReverseProxy, []}]
  end

  defp deps do
    [{:plug, "~> 1.0.2"},
     {:cowboy, "~> 1.0.2"},
     {:httpoison, "~> 0.7.1"},

     {:earmark, "~> 0.1.17", only: :docs},
     {:ex_doc, "~> 0.10.0", only: :docs},

     {:dogma, "~> 0.0", only: :test},
     {:excoveralls, "~> 0.3.11", only: :test},
     {:dialyze, "~> 0.2.0", only: :test}]
  end

  defp description do
    """
    A Plug based, reverse proxy server.
    """
  end

  defp package do
    %{maintainers: ["Shane Logsdon"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/slogsdon/elixir-reverse-proxy"}}
  end
end
