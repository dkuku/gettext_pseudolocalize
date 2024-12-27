defmodule GettextPseudolocalize.Process do
  @moduledoc """
  Handles the pseudolocalization of strings for gettext translations.

  This module provides functionality to convert regular strings into pseudolocalized versions
  while preserving interpolation variables. Pseudolocalization helps identify hardcoded strings,
  character encoding issues, and UI problems by converting ASCII characters to similar-looking
  Unicode characters.

  The conversion:
  - Preserves gettext interpolation variables (e.g., %{name})
  - Converts ASCII characters to accented Unicode equivalents
  - Wraps the result in brackets (⟦...⟧) for easy identification
  """

  @doc """
  Converts a string to its pseudolocalized equivalent.

  This function preserves gettext interpolation variables while converting regular text
  to pseudolocalized versions. The result is wrapped in special brackets for easy identification.

  ## Examples

      iex> GettextPseudolocalize.Process.convert("Hello")
      "⟦Ȟêĺĺø⟧"

      iex> GettextPseudolocalize.Process.convert("Hello %{name}")
      "⟦Ȟêĺĺø %{name}⟧"

  """
  def convert(string) when is_binary(string) do
    string
    |> split_interpolations()
    |> Enum.map(&process_part/1)
    |> Enum.join()
    |> add_padding()
    |> wrap_brackets()
  end

  defp add_padding(string) do
    size = length(String.graphemes(string))
    padding = if size > 10, do: trunc(Float.ceil(size * 1.4)), else: 15
    String.pad_trailing(string, padding, "~")
  end

  defp wrap_brackets(string) do
    "⟦#{string}⟧"
  end

  # Split string into parts using recursive parsing
  defp split_interpolations(string), do: do_split_interpolations(string, [], "")

  defp do_split_interpolations("", acc, current) do
    Enum.reverse(if current == "", do: acc, else: [current | acc])
  end

  defp do_split_interpolations("%" <> "{" <> rest, acc, current) do
    acc = if current == "", do: acc, else: [current | acc]
    {var, rest} = extract_variable(rest)
    do_split_interpolations(rest, ["%{" <> var <> "}" | acc], "")
  end

  defp do_split_interpolations(<<c::utf8, rest::binary>>, acc, current) do
    do_split_interpolations(rest, acc, current <> <<c::utf8>>)
  end

  defp extract_variable(str), do: do_extract_variable(str, [])

  defp do_extract_variable("}" <> rest, acc), do: {Enum.reverse(acc) |> to_string(), rest}

  defp do_extract_variable(<<c::utf8, rest::binary>>, acc),
    do: do_extract_variable(rest, [<<c::utf8>> | acc])

  # Process each part - either expand characters or keep as is for interpolations
  defp process_part(<<"%{", _::binary>> = part), do: part
  defp process_part(part), do: expand_characters(part)

  # Map of ASCII characters to their pseudo-localized equivalents
  @char_map %{
    "A" => "Å",
    "B" => "Ɓ",
    "C" => "Ċ",
    "D" => "Đ",
    "E" => "Ȅ",
    "F" => "Ḟ",
    "G" => "Ġ",
    "H" => "Ȟ",
    "I" => "İ",
    "J" => "Ĵ",
    "K" => "Ǩ",
    "L" => "Ĺ",
    "M" => "Ṁ",
    "N" => "Ñ",
    "O" => "Ò",
    "P" => "Ƥ",
    "Q" => "Ꝗ",
    "R" => "Ȓ",
    "S" => "Ș",
    "T" => "Ť",
    "U" => "Ü",
    "V" => "Ṽ",
    "W" => "Ẃ",
    "X" => "Ẍ",
    "Y" => "Ẏ",
    "Z" => "Ž",
    "a" => "à",
    "b" => "ƀ",
    "c" => "ċ",
    "d" => "đ",
    "e" => "ê",
    "f" => "ƒ",
    "g" => "ğ",
    "h" => "ȟ",
    "i" => "í",
    "j" => "ǰ",
    "k" => "ǩ",
    "l" => "ĺ",
    "m" => "ɱ",
    "n" => "ñ",
    "o" => "ø",
    "p" => "ƥ",
    "q" => "ʠ",
    "r" => "ȓ",
    "s" => "š",
    "t" => "ť",
    "u" => "ü",
    "v" => "ṽ",
    "w" => "ẁ",
    "x" => "ẋ",
    "y" => "ÿ",
    "z" => "ź",
    "0" => "𝟘",
    "1" => "𝟙",
    "2" => "𝟚",
    "3" => "𝟛",
    "4" => "𝟜",
    "5" => "𝟝",
    "6" => "𝟞",
    "7" => "𝟟",
    "8" => "𝟠",
    "9" => "𝟡"
  }

  defp expand_characters(string) do
    String.graphemes(string)
    |> Enum.map(fn char -> Map.get(@char_map, char, char) end)
    |> Enum.join()
  end
end
