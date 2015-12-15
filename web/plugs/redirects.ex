defmodule Exbugs.Redirects do
  import Plug.Conn
  use Exbugs.Web, :controller

  def redirect_unless_signed_in(conn, _params) do
    if !logged_in?(conn) do
      conn |> redirect(to: "/")
    else
      conn
    end
  end

  def redirect_if_signed_in(conn, _params) do
    if logged_in?(conn) do
      conn |> redirect(to: "/")
    else
      conn
    end
  end
end
