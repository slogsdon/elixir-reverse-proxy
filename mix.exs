defmodule ReverseProxy.Mixfile do
  use Mix.Project

  def project do
    [app: :reverse_proxy,
     version: "0.3.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     name: "ReverseProxy",
     description: description(),
     package: package(),
     docs: [extras: ["README.md"],
            main: "readme"],
     test_coverage: [tool: ExCoveralls]]
  end

  def application do
    [applications: [:logger, :plug, :cowboy, :httpoison],
     mod: {ReverseProxy, []}]
  end

  defp deps do
    [{:plug, "~> 1.2"},
     {:cowboy, "~> 1.0"},
     {:httpoison, "~> 0.9"},
     {:poison, "~> 3.1"},

     {:earmark, "~> 1.0", only: :dev},
     {:ex_doc, "~> 0.14", only: :dev},

     {:credo, "~> 0.5", only: [:dev, :test]},
     {:excoveralls, "~> 0.5", only: :test},
     {:dialyze, "~> 0.2", only: :test}]
  end

  defp description do
    """
    A Plug based reverse proxy server.
    """
  end

  defp package do
    %{maintainers: ["Shane Logsdon"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/slogsdon/elixir-reverse-proxy"}}
  end
end
