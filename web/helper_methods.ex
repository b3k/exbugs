defmodule Exbugs.HelperMethods do
  import Phoenix.HTML.Tag
  import EctoGettext

  def show_attribute(attr) do
    localize_attribute(Exbugs.Gettext, attr)
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
