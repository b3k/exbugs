defmodule Exbugs.API.UserController do
  use Exbugs.Web, :controller

  alias Exbugs.{Repo, User}

  def autocomplete(conn, _params) do
    query = conn.params["query"] || ""
      |> String.downcase

    users = case query do
      "" -> []
      query -> from(u in User, where: like(u.username, ^"#{query}%")) |> Repo.all
    end

    render conn, users: users
  end
end
