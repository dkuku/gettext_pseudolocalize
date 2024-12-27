defmodule GettextPseudolocalize.MixProject do
  use Mix.Project

  def project do
    [
      app: :gettext_pseudolocalize,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:gettext, "~> 0.26"},
      {:expo, "~> 1.1"}
    ]
  end
end
