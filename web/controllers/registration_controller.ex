defmodule Exbugs.RegistrationController do
  use Exbugs.Web, :controller
  alias Exbugs.User
  import Exbugs.Redirects, only: [redirect_if_signed_in: 2]

  plug :redirect_if_signed_in
  plug :put_layout, "sign.html"

  def new(conn, _params) do
    changeset = User.create_changeset(%User{})

    render conn, "new.html",
      page_title: dgettext("sign", "Sign up"),
      changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.create_changeset(%User{}, user_params)

    case Exbugs.Registration.create(changeset, Exbugs.Repo) do
      {:ok, changeset} ->
        user = Repo.get_by(User, email: changeset.email)

        conn
        |> assign(:page_title, dgettext("sign", "Sign up"))
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, dgettext("sign", "Your account was created"))
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
end
