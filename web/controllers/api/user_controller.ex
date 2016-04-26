defmodule Exbugs.API.UserController do
  use Exbugs.Web, :controller

  alias Exbugs.{Repo, User}

  def autocomplete(conn, _params) do
    param = conn.params["query"] |> String.downcase

    users = from(u in User, where: like(u.username, ^"#{param}%"))
      |> Repo.all

    render conn, users: users
  end
end
