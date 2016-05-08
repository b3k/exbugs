defmodule Exbugs.HelperMethods do
  import Phoenix.HTML.Tag

  def show_attribute(attr, :upcase), do: show_attribute(attr) |> String.upcase
  def show_attribute(attr) do
    attr = attr
      |> Atom.to_string
      |> String.replace("_", " ")
      |> String.capitalize

    Gettext.dgettext(Exbugs.Gettext, "attributes", attr)
    |> String.capitalize
  end

  def correct_image_path(path) do
    String.replace path, "priv/static/", "/"
  end

  def show_avatar(user, size \\ :small, class \\ "") do
    tag(
      :img,
      src: correct_image_path(Exbugs.Avatar.url({user.avatar, user}, size)),
      class: class
    )
  end

  def show_logo(company, size \\ :small, class \\ "") do
    tag(
      :img,
      src: correct_image_path(Exbugs.Logo.url({company.logo, company}, size)),
      class: class
    )
  end
end
