defmodule Mix.Tasks.Gettext.PseudolocalizeTest do
  use ExUnit.Case

  setup do
    # Ensure we have a clean xx locale directory
    xx_dir = Path.join(["test", "fixtures", "xx", "LC_MESSAGES"])
    File.rm_rf!(xx_dir)
    File.mkdir_p!(xx_dir)

    # Create a test PO file
    po_content = """
    msgid ""
    msgstr ""
    "Language: xx\\n"
    "Plural-Forms: nplurals=2\\n"

    #: lib/gettext_pseudolocalize.ex:5
    msgid "Hello %{name}"
    msgstr ""

    # Plural form
    msgid "Here is the string to translate"
    msgid_plural "Here are the %{count} strings to translate"
    msgstr[0] ""
    msgstr[1] ""
    """

    po_file = Path.join(xx_dir, "default.po")
    File.write!(po_file, po_content)

    on_exit(fn ->
      File.rm_rf!(xx_dir)
    end)

    {:ok, dir: xx_dir, po_file: po_file}
  end

  test "pseudolocalizes empty msgstr entries", %{dir: dir, po_file: po_file} do
    Mix.Task.rerun("gettext.pseudolocalize", [dir])
    {:ok, po} = Expo.PO.parse_file(po_file)

    # Test single form
    hello_msg =
      Enum.find(po.messages, fn msg ->
        match?(%Expo.Message.Singular{msgid: ["Hello %{name}"]}, msg)
      end)

    assert [msgstr] = hello_msg.msgstr
    assert msgstr =~ "name"

    # Test plural form
    plural_msg =
      Enum.find(po.messages, fn msg ->
        match?(%Expo.Message.Plural{}, msg)
      end)

    assert hd(plural_msg.msgstr[0]) =~ "⟦Ȟêȓê íš ťȟê šťȓíñğ ťø ťȓàñšĺàťê~~~~~~~~~~~~~⟧"

    assert hd(plural_msg.msgstr[1]) =~
             "⟦Ȟêȓê àȓê ťȟê %{count} šťȓíñğš ťø ťȓàñšĺàťê~~~~~~~~~~~~~~~~~⟧"
  end
end
