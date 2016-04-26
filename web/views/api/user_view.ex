defmodule Exbugs.API.UserView do
  use Exbugs.Web, :view

  def render("autocomplete.json", %{users: users}) do
    users = users |> Enum.map(&(&1.username))
    IO.inspect users

    %{"suggestions": users}
  end
end
