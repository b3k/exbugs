defmodule Exbugs.RegistrationControllerTest do
  use Exbugs.ConnCase

  alias Exbugs.{User, Repo}

  @valid_attrs %{email: "email@exbugs.me", username: "username", password: "password"}
  @invalid_attrs %{email: "", username: "", password: ""}

  setup do
    {:ok, conn: conn()}
  end

  test "render template on new", %{conn: conn} do
    conn = get(conn, registration_path(conn, :new))
    assert html_response(conn, 200) =~ "Back to site"
  end

  test "authorize, create account and redirect when data is valid", %{conn: conn} do
    conn = post(conn, registration_path(conn, :create), user: @valid_attrs)

    assert redirected_to(conn) == "/"
    assert Repo.get_by(User, username: @valid_attrs.username)
    assert Exbugs.Session.logged_in?(conn)
  end

  test "does not create an account and renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, registration_path(conn, :create), user: @invalid_attrs)

    assert html_response(conn, 200) =~ "Back to site"
    refute Exbugs.Session.logged_in?(conn)
  end
end
