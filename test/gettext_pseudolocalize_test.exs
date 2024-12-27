defmodule GettextPseudolocalizeTest do
  use ExUnit.Case
  import GettextPseudolocalize
  alias GettextPseudolocalize.Process

  setup do
    # Set up Gettext to use our locale
    Gettext.put_locale(GettextPseudolocalize.Gettext, "xx")
    :ok
  end

  describe "Process.convert/1" do
    test "handles short strings with fixed padding" do
      result = Process.convert("Hello")
      assert result =~ "⟦Ȟêĺĺø"
      # content 15 + 2 brackets
      assert String.length(result) == 17
    end

    test "handles longer strings with proportional padding" do
      result = Process.convert("This is a longer test string")
      assert result =~ "⟦Ťȟíš íš à ĺøñğêȓ ťêšť šťȓíñğ"
      # Original length = 26, so padding should be ~11 chars (40% of 26 rounded up)
      assert String.length(result) > String.length("This is a longer test string") * 1.3
    end

    test "preserves interpolation variables" do
      result = Process.convert("Hello %{name}, welcome!")
      assert result =~ "%{name}"
      assert String.ends_with?(result, "⟧")
      assert String.starts_with?(result, "⟦")
    end
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
