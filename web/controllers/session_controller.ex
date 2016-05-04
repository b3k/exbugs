defmodule Exbugs.SessionController do
  use Exbugs.Web, :controller
  import Exbugs.Redirects, only: [redirect_if_signed_in: 2]
  alias Exbugs.Session

  plug :redirect_if_signed_in when action in [:new, :create]
  plug :put_layout, "sign.html"

  def new(conn, _params) do
    render conn, "new.html",
      page_title: dgettext("sign", "Sign in")
  end

  def create(conn, %{"session" => session_params}) do
    case Session.login(session_params, Exbugs.Repo) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, dgettext("sign", "Logged in"))
        |> redirect(to: "/")
      :error ->
        conn
        |> assign(:page_title, dgettext("sign", "Sign in"))
        |> put_flash(:info, dgettext("errors", "Wrong email or password"))
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> put_flash(:info, dgettext("sign", "Logged out"))
    |> redirect(to: "/")
  end
end
