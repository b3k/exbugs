defmodule Exbugs.BoardTest do
  use Exbugs.ModelCase

  alias Exbugs.Board

  import Exbugs.Factory

  @valid_attrs %{name: "name", about: "About info"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    company = create(:company, user: create(:user))
    board = Ecto.Model.build(company, :boards)
    changeset = Board.changeset(board, @valid_attrs)

    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    company = create(:company, user: create(:user))
    board = Ecto.Model.build(company, :boards)
    changeset = Board.changeset(board, @invalid_attrs)

    refute changeset.valid?
  end
end
