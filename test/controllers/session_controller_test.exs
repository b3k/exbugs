defmodule Exbugs.SessionControllerTest do
  use Exbugs.ConnCase

  import Exbugs.Factory

  setup do
    {:ok, conn: conn()}
  end

  test "render template on new", %{conn: conn} do
    conn = get(conn, session_path(conn, :new))
    assert html_response(conn, 200) =~ "Back to site"
  end

  test "authorize and redirect when data is valid", %{conn: conn} do
    user = create(:user)
    conn = post(conn, session_path(conn, :new), session: %{email: user.email, password: "password"})

    assert redirected_to(conn) == "/"
    assert Exbugs.Session.logged_in?(conn)
  end

  test "render errors and not authorize when data isn't valid" do
    conn = post(conn, session_path(conn, :new), session: %{email: "", password: ""})

    assert html_response(conn, 200) =~ "Back to site"
    refute Exbugs.Session.logged_in?(conn)
  end

  test "logout and redirect", %{conn: conn} do
    user = create(:user)
    conn = guardian_login(user) |> get(session_path(conn, :delete))

    assert redirected_to(conn) == "/"
    refute Exbugs.Session.logged_in?(conn)
  end
end
