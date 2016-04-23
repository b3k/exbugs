defmodule Exbugs.DashboardController do
  use Exbugs.Web, :controller

  def index(conn, _params) do
    render conn, "index.html",
      page_title: dgettext("dashboard", "Dashboard")
  end
end
