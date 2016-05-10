defmodule Exbugs.BoardControllerTest do
  use Exbugs.ConnCase

  alias Exbugs.{Repo, Board}
  import Exbugs.Factory

  @valid_attrs %{about: "some content", name: "name"}
  @invalid_attrs %{name: "name with spaces"}

  setup do
    user = create(:user)
    company = create(:company, user: user)
    _member = create(:member, user: user, company: company, role: "creator")
    {:ok, conn: conn(), user: user, company: company}
  end

  test "renders form for new resources", %{conn: conn, user: user, company: company} do
    conn = guardian_login(user)
    |> get(company_board_path(conn, :new, company.name))

    assert html_response(conn, 200) =~ "New board"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, user: user, company: company} do
    conn = guardian_login(user) |>
    post(company_board_path(conn, :create, company.name), board: @valid_attrs)

    assert redirected_to(conn) == company_path(conn, :show, company.name)
    assert Repo.get_by(Board, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: user, company: company} do
    conn = guardian_login(user)
    |> post(company_board_path(conn, :create, company.name), board: @invalid_attrs)

    assert html_response(conn, 200) =~ "New board"
  end

  test "renders form for editing chosen resource", %{conn: conn, user: user, company: company} do
    board = create(:board, company: company)

    conn = guardian_login(user)
    |> get(company_board_path(conn, :edit, company.name, board.name))

    assert html_response(conn, 200) =~ "Edit board"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user, company: company} do
    board = create(:board, company: company)

    conn = guardian_login(user)
    |> put(company_board_path(conn, :update, company.name, board.name), board: @valid_attrs)

    assert redirected_to(conn) == company_path(conn, :show, company.name)
    assert Repo.get_by(Board, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user, company: company} do
    board = create(:board, company: company)

    conn = guardian_login(user)
    |> put(company_board_path(conn, :update, company.name, board.name), board: @invalid_attrs)

    assert html_response(conn, 200) =~ "Edit board"
  end

  test "deletes chosen resource", %{conn: conn, user: user, company: company} do
    board = create(:board, company: company)

    conn = guardian_login(user)
    |> delete(company_board_path(conn, :delete, company.name, board.name))

    assert redirected_to(conn) == company_path(conn, :show, company.name)
    refute Repo.get(Board, board.id)
  end
end
