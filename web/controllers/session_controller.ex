defmodule Exbugs.SessionController do
  use Exbugs.Web, :controller
  import Exbugs.Redirects, only: [redirect_if_signed_in: 2]

  plug :redirect_if_signed_in when action in [:new, :create]
  plug :put_layout, "sign.html"

  def new(conn, _params) do
    render conn, "new.html",
      page_title: dgettext("sign", "Sign in")
  end

  def create(conn, %{"session" => session_params}) do
    case Exbugs.Session.login(session_params, Exbugs.Repo) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, dgettext("sign", "Logged in"))
        |> redirect(to: "/")
      :error ->
        conn
        |> assign(:page_title, dgettext("sign", "Sign in"))
        |> put_flash(:info, dgettext("errors", "Wrong email or password"))
        |> render("new.html")
    end
  end

  def delete(conn, _oarams) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, dgettext("sign", "Logged out"))
    |> redirect(to: "/")
  end
end
