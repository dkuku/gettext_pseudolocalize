defmodule Mix.Tasks.Gettext.Pseudolocalize do
  use Mix.Task

  @shortdoc "Creates a pseudolocalized version of the xx locale"
  @moduledoc """
  Creates a pseudolocalized version of the xx locale for testing internationalization.

  Pseudolocalization is a software testing method used to verify internationalization aspects
  of software. It replaces ordinary characters with accented, uncommon, or otherwise modified
  versions while maintaining the readability of the text.

  ## Usage

  First, extract your gettext strings:

      $ mix gettext.extract

  Then run the pseudolocalization:

      $ mix gettext.pseudolocalize

  This will process all .po files in the xx locale directory (priv/gettext/xx/LC_MESSAGES/).
  """

  @impl Mix.Task
  def run(args) do
    # First extract and merge

    target_dir =
      case args do
        [custom_dir] ->
          custom_dir

        _ ->
          Mix.Task.run("gettext.merge", ["priv/gettext", "--locale=xx"])
          Path.join(["priv", "gettext", "xx", "LC_MESSAGES"])
      end

    # Process all .po files in the target directory
    target_dir
    |> Path.join("*.po")
    |> Path.wildcard()
    |> Enum.each(&process_file(&1))

    Mix.shell().info([:green, "✓ Pseudolocalization complete"])
  end

  defp process_file(file_path) do
    with {:ok, po} <- Expo.PO.parse_file(file_path),
         updated_po = update_messages(po) do
      content = Expo.PO.compose(updated_po)
      File.write!(file_path, content)
      Mix.shell().info("Processed #{Path.basename(file_path)}")
    end
  end

  defp update_messages(%Expo.Messages{} = po) do
    updated_messages = Enum.map(po.messages, &update_message/1)
    %{po | messages: updated_messages}
  end

  defp update_message(%Expo.Message.Singular{msgstr: [""]} = message) do
    %{message | msgstr: [pseudolocalize(message.msgid)]}
  end

  defp update_message(%Expo.Message.Plural{msgstr: msgstr} = message) when is_map(msgstr) do
    updated_msgstr =
      Map.new(msgstr, fn
        {index, [""]} when index == 0 -> {index, [pseudolocalize(message.msgid)]}
        {index, [""]} -> {index, [pseudolocalize(message.msgid_plural)]}
        other -> other
      end)

    %{message | msgstr: updated_msgstr}
  end

  defp update_message(message), do: message

  defp pseudolocalize([string]) when is_binary(string) do
    GettextPseudolocalize.Process.convert(string)
  end
end
