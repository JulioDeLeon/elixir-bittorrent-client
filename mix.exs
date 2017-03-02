defmodule BittorrentClient.Mixfile do
  use Mix.Project

  def project do
    [app: :bittorrent_client,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :gproc, :cowboy, :plug] 
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:poison, "~> 3.0"},                     # json library
      {:cowboy, "1.0.0"},                     # http library
      {:plug, "~> 1.0"},                   # http wrapper for cowboy
      {:httpoison, "~> 0.4.3", only: :test},  # test framework for http library
      {:meck, "~> 0.8.2", only: :test}        # mocking library
    ]
  end
end
