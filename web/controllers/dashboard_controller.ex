defmodule Exbugs.DashboardController do
  use Exbugs.Web, :controller

  alias Exbugs.Company

  def index(conn, _params) do
    case logged_in?(conn) do
      true ->
        companies = Company.user_companies(current_user(conn), 3)


        render conn, "index.html",
          page_title: dgettext("dashboard", "Dashboard"),
          companies: companies

    false ->
      render conn, Exbugs.SharedView, "please_sign_in.html",
        page_title: gettext("Please sign in")
    end

  end
end
