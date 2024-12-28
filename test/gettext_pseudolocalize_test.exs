defmodule GettextPseudolocalizeTest do
  use ExUnit.Case
  import GettextPseudolocalize

  setup do
    # Set up Gettext to use our locale
    Gettext.put_locale(GettextPseudolocalize.Gettext, "xx")
    :ok
  end

  test "hello/0 with default name" do
    assert hello() =~ "⟦ȟêĺĺø world"
  end

  test "hello/1 with custom name" do
    assert hello("test") =~ "⟦ȟêĺĺø test"
  end

  test "translate/1 with singular and plural forms" do
    assert translate(1) =~ "⟦Ȟêȓê íš ťȟê šťȓíñğ ťø ťȓàñšĺàťê"
    assert translate(2) =~ "⟦Ȟêȓê àȓê ťȟê 2 šťȓíñğš ťø ťȓàñšĺàťê"
  end
end
