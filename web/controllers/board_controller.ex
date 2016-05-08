defmodule Exbugs.BoardController do
  use Exbugs.Web, :controller

  alias Exbugs.{Board, Company}

  import Exbugs.Abilities, only: [can_manage_company?: 2]
  import Exbugs.Redirects, only: [redirect_unless_signed_in: 2, redirect_unless: 2]

  plug :redirect_unless_signed_in
  plug :authorize
  plug :scrub_params, "board" when action in [:create, :update]

  def new(conn, _params) do
    company = Repo.get_by(Company, name: conn.params["company_name"])
    changeset = Board.changeset(%Board{})

    render conn, "new.html",
      page_title: dgettext("boards", "New board"),
      changeset: changeset,
      company: company
  end

  def create(conn, %{"board" => board_params}) do
    company = Repo.get_by(Company, name: conn.params["company_name"])

    board = Ecto.Model.build(company, :boards)
    changeset = Board.changeset(board, board_params)

    case Repo.insert(changeset) do
      {:ok, _board} ->
        conn
        |> put_flash(:info, gettext("%{attribute} created successfully", [attribute: "Board"]))
        |> redirect(to: company_path(conn, :show, company.name))
      {:error, changeset} ->
        render conn, "new.html",
          page_title: dgettext("boards", "New board"),
          changeset: changeset,
          company: company
    end
  end

  def show(conn, %{"name" => name}) do
    company = Repo.get_by(Company, name: conn.params["company_name"])
    board = Repo.get_by!(Board, %{name: name, company_id: company.id})

    render conn, "show.html",
      page_title: dgettext("boards", "New board"),
      board: board
  end

  def edit(conn, %{"name" => name}) do
    company = Repo.get_by(Company, name: conn.params["company_name"])
    board = Repo.get_by!(Board, %{name: name, company_id: company.id})

    changeset = Board.changeset(board)
    render conn, "edit.html",
      page_title: dgettext("boards", "Edit board"),
      board: board,
      company: company,
      changeset: changeset
  end

  def update(conn, %{"name" => name, "board" => board_params}) do
    company = Repo.get_by(Company, name: conn.params["company_name"])
    board = Repo.get_by!(Board, %{name: name, company_id: company.id})

    changeset = Board.changeset(board, board_params)

    case Repo.update(changeset) do
      {:ok, _board} ->
        conn
        |> put_flash(:info, gettext("%{attribute} updated successfully", [attribute: "Board"]))
        |> redirect(to: company_path(conn, :show, company.name))
      {:error, changeset} ->
        render conn, "edit.html",
          page_title: dgettext("boards", "Edit board"),
          board: board,
          company: company,
          changeset: changeset
    end
  end

  def delete(conn, %{"name" => name}) do
    company = Repo.get_by(Company, name: conn.params["company_name"])
    board = Repo.get_by!(Board, %{name: name, company_id: company.id})

    Repo.delete!(board)

    conn
    |> put_flash(:info, gettext("%{attribute} deleted successfully", [attribute: "Board"]))
    |> redirect(to: company_path(conn, :show, company.name))
  end

  defp authorize(conn, _params) do
    company = Repo.get_by(Company, name: conn.params["company_name"])
    redirect_unless(conn, can_manage_company?(current_user(conn), company))
  end
end
