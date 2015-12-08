defmodule Exbugs.DashboardController do
  use Exbugs.Web, :controller

  def index(conn, _params) do
    conn
    |> render "index.html", page_title: "Dashboard"
  end
end
