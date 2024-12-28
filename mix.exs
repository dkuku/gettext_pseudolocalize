defmodule GettextPseudolocalize.MixProject do
  use Mix.Project

  @version "0.1.1"
  @source_url "https://github.com/dkuku/gettext_pseudolocalize"

  def project do
    [
      app: :gettext_pseudolocalize,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      name: "GettextPseudolocalize",
      source_url: @source_url
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:gettext, "~> 0.26"},
      {:expo, "~> 1.1"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    A tool for pseudolocalizing Gettext translations in Elixir applications.
    Helps identify hardcoded strings, character encoding issues, and UI problems by converting
    ASCII characters to similar-looking Unicode characters with text expansion simulation.
    """
  end

  defp package do
    [
      name: "gettext_pseudolocalize",
      files: ~w(lib mix.exs README.md),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
