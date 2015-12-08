defmodule Exbugs.RegistrationController do
  use Exbugs.Web, :controller
  alias Exbugs.User

  plug :redirect_if_signed_in
  plug :put_layout, "sign.html"

  def new(conn, _params) do
    changeset = User.changeset(%User{})

    conn
    |> assign(:page_title, dgettext("sign", "Sign up"))
    |> assign(:changeset, changeset)
    |> render "new.html"
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Exbugs.Registration.create(changeset, Exbugs.Repo) do
      {:ok, changeset} ->
        user = Repo.get_by(User, email: changeset.email)

        conn
        |> assign(:page_title, dgettext("sign", "Sign up"))
        |> put_session(:current_user, user.id)
        |> put_flash(:info, dgettext("sign", "Your account was created"))
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  defp redirect_if_signed_in(conn, _params) do
    if logged_in?(conn) do
      conn |> redirect(to: "/")
    else
      conn
    end
  end
end
