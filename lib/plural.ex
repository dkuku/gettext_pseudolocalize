defmodule GettextPseudolocalize.Plural do
  @behaviour Gettext.Plural

  def nplurals("xx"), do: 2

  def plural("xx", 1), do: 0
  def plural("xx", _), do: 1

  # Fall back to Gettext.Plural
  defdelegate nplurals(locale), to: Gettext.Plural
  defdelegate plural(locale, n), to: Gettext.Plural
end
