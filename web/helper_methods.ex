defmodule Exbugs.HelperMethods do
  import Phoenix.HTML.Tag

  def show_attribute(attr) do
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
end
