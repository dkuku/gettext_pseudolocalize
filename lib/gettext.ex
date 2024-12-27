defmodule GettextPseudolocalize.Gettext do
  use Gettext.Backend,
    otp_app: :gettext_pseudolocalize,
    default_locale: "xx",
    plural_forms: GettextPseudolocalize.Plural
end
