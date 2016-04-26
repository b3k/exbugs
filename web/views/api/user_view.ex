defmodule Exbugs.API.UserView do
  use Exbugs.Web, :view

  def render("autocomplete.json", %{users: users}) do
    users = users |> Enum.map(&(&1.username))
    %{"suggestions": users}
  end
end
