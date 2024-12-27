defmodule GettextPseudolocalize do
  use Gettext, backend: GettextPseudolocalize.Gettext

  def hello(name \\ "world") do
    Gettext.with_locale(GettextPseudolocalize.Gettext, "xx", fn ->
      gettext("hello %{name}", name: name)
    end)
  end

  def translate(count) do
    Gettext.with_locale(GettextPseudolocalize.Gettext, "xx", fn ->
      ngettext(
        "Here is the string to translate",
        "Here are the %{count} strings to translate",
        count,
        count: count
      )
    end)
  end
end
