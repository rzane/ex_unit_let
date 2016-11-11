defmodule ExUnitLet.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_unit_let,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "A simple let macro for ExUnit.",
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
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
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp package do
    [files: ["lib", "config", "mix.exs", "README.md", "LICENSE.txt"],
     maintainers: ["Ray Zane"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/rzane/ex_unit_let"}]
  end
end
