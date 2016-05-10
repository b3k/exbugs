defmodule Exbugs.TicketController do
  use Exbugs.Web, :controller

  alias Exbugs.{Ticket, Board, Company, Tag}

  import Exbugs.Redirects, only: [redirect_if_private: 2, redirect_unless_signed_in: 2]

  plug :scrub_params, "ticket" when action in [:create, :update]
  plug :redirect_unless_signed_in when not(action in [:show, :index])
  plug :redirect_if_private

  def index(conn, params) do
    board = set_board(conn)
    page = assoc(board, :tickets) |> Repo.paginate(params)

    render conn, "index.html",
      page_title: board.name <> " - "  <> dgettext("tickets", "Tickets"),
      tickets: page.entries
  end

  def new(conn, _params) do
    board = set_board(conn) |> Repo.preload(:company)
    boards = Board.for_select(board.company)
    changeset = Ticket.changeset(%Ticket{})

    render conn, "new.html",
      page_title: dgettext("tickets", "New ticket"),
      changeset: changeset,
      board: board,
      boards: boards
  end

  def create(conn, %{"ticket" => ticket_params}) do
    board = set_board(conn) |> Repo.preload(:company)
    boards = Board.for_select(board.company)

    ticket = Ecto.build_assoc(current_user(conn), :tickets)
    changeset = Ticket.changeset(ticket, ticket_params)

    case Repo.insert(changeset) do
      {:ok, ticket} ->
        # TODO: Change when release Multi
        Exbugs.Tag.add_tags("ticket", ticket, ticket_params["tags"])

        conn
        |> put_flash(:info, gettext("%{attribute} created successfully", [attribute: "Ticket"]))
        |> redirect(to: company_board_ticket_path(conn, :show, board.company.name, board.name, ticket))
      {:error, changeset} ->
        render conn, "new.html",
          changeset: changeset,
          board: board,
          boards: boards
    end
  end

  def show(conn, %{"id" => id}) do
    board = set_board(conn)
    ticket = Repo.get!(Ticket, id)
    tags = Tag.tags_for(Exbugs.Ticket, ticket)

    render conn, "show.html",
      ticket: ticket,
      board: board,
      tags: tags
  end

  def edit(conn, %{"id" => id}) do
    board = set_board(conn)
    ticket = Repo.get!(Ticket, id)
    changeset = Ticket.changeset(ticket)
    render(conn, "edit.html", ticket: ticket, changeset: changeset, board: board)
  end

  def update(conn, %{"id" => id, "ticket" => ticket_params}) do
    board = set_board(conn)
    ticket = Repo.get!(Ticket, id)
    changeset = Ticket.changeset(ticket, ticket_params)

    case Repo.update(changeset) do
      {:ok, ticket} ->
        conn
        |> put_flash(:info, "Ticket updated successfully.")
        |> redirect(to: company_board_ticket_path(conn, :show, board.company.name, board.name, ticket))
      {:error, changeset} ->
        render(conn, "edit.html", ticket: ticket, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    board = set_board(conn)
    ticket = Repo.get!(Ticket, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(ticket)

    conn
    |> put_flash(:info, "Ticket deleted successfully.")
    |> redirect(to: company_board_ticket_path(conn, :index, board.company.name, board.name))
  end

  defp set_board(conn) do
    company = Repo.get_by(Company, name: conn.params["company_name"])

    Repo.get_by(Board, %{name: conn.params["board_name"], company_id: company.id})
      |> Repo.preload(:company)
  end
end
