defmodule GettextPseudolocalize.ProcessTest do
  use ExUnit.Case
  doctest GettextPseudolocalize.Process
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

    test "handles short strings with fixed padding and interpolation" do
      result = Process.convert("Hi %{n}")
      assert result =~ "⟦Ȟí %{n}~~~~~~~~⟧"
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

    test "preserves interpolation with multiple variables" do
      result = Process.convert("Hello %{name}, your age is %{age}!")
      assert result =~ "%{name}"
      assert result =~ "%{age}"
      assert result =~ "⟦Ȟêĺĺø %{name}, ÿøüȓ àğê íš %{age}!~~~~~~~~~~~~~~⟧"

      assert String.ends_with?(result, "⟧")
      assert String.starts_with?(result, "⟦")
    end

    test "just interpolation" do
      result = Process.convert("%{name}")
      assert result =~ "%{name}~~~~~~~~"
      assert String.ends_with?(result, "⟧")
      assert String.starts_with?(result, "⟦")
    end

    test "invalid interpolation" do
      result = Process.convert("Hello %{name, welcome!")
      assert result =~ " %{name, welcome!"
      assert String.ends_with?(result, "⟧")
      assert String.starts_with?(result, "⟦")
    end
  end
end
