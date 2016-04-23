defmodule Exbugs.Setting.ProfileController do
  use Exbugs.Web, :controller
  alias Exbugs.User
  import Exbugs.Redirects, only: [redirect_unless_signed_in: 2]

  plug :redirect_unless_signed_in

  def edit(conn, _params) do
    user = Repo.get(User, current_user(conn).id)
    changeset = User.update_changeset(user)

    conn
    |> assign(:page_title, dgettext("settings", "Profile settings"))
    |> assign(:user, user)
    |> assign(:changeset, changeset)
    |> render("edit.html")
  end

  def update(conn, %{"user" => user_params}) do
    user = Repo.get!(User, current_user(conn).id)
    changeset = User.update_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, dgettext("settings", "Your profile was updated"))
        |> redirect(to: profile_path(conn, :edit))
      {:error, changeset} ->
        conn
        |> assign(:page_title, dgettext("settings", "Profile settings"))
        |> assign(:user, user)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end
end
