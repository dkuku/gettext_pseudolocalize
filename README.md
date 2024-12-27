# Gettext Pseudolocalize

A Mix task for pseudolocalizing Gettext translations in Elixir applications. Pseudolocalization is a software testing method used to verify internationalization aspects of software by replacing ordinary characters with accented or modified versions while maintaining readability.

## Features

- Preserves Gettext interpolation variables (e.g., `%{name}`)
- Converts ASCII characters to accented Unicode equivalents
- Wraps strings in brackets (⟦...⟧) for easy identification
- Maintains all PO file headers and metadata
- Preserves existing translations

## Installation

Add `gettext_pseudolocalize` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gettext_pseudolocalize, "~> 0.1.0"}
  ]
end
```

## Usage

1. First, extract your gettext strings:

```bash
mix gettext.extract
```

2. Merge them into the xx locale:

```bash
mix gettext.merge priv/gettext --locale=xx
```

3. Run the pseudolocalization:

```bash
mix gettext.pseudolocalize
```

This will process all .po files in your xx locale directory (`priv/gettext/xx/LC_MESSAGES/`).

### Example

Original string in .pot file:
```
msgid "Hello %{name}"
msgstr ""
```

After pseudolocalization in xx locale:
```
msgid "Hello %{name}"
msgstr "⟦Ĥéłłô %{name}⟧"
```

## Benefits

Pseudolocalization helps identify:
- Hardcoded strings that should be localized
- Character encoding issues
- UI issues with different character lengths
- String concatenation issues
- Unicode/font support problems

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create new Pull Request

## License

This project is licensed under the MIT License.
