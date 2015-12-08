defmodule Exbugs.SessionController do
  use Exbugs.Web, :controller

  plug :redirect_if_signed_in when action in [:new, :create]
  plug :put_layout, "sign.html"

  def new(conn, _params) do
    conn
    |> assign(:page_title, dgettext("sign", "Sign in"))
    |> render "new.html"
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

  defp redirect_if_signed_in(conn, _params) do
    if logged_in?(conn) do
      conn |> redirect(to: "/")
    else
      conn
    end
  end
end
