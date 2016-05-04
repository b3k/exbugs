defmodule Exbugs.DashboardControllerTest do
  use Exbugs.ConnCase

  import Exbugs.Factory

  setup do
    {:ok, conn: conn()}
  end

  test "renders placeholder on index when isn't authorized", %{conn: conn} do
    conn = get(conn, dashboard_path(conn, :index))
    assert html_response(conn, 200) =~ "Please sign in to show this page"
  end

  test "renders template on index when is authorized", %{conn: conn} do
    user = create(:user)

    conn = guardian_login(user) |> get(dashboard_path(conn, :index))
    assert html_response(conn, 200) =~ "Dashboard"
  end
end
