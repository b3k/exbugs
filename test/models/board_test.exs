defmodule Exbugs.BoardTest do
  use Exbugs.ModelCase

  alias Exbugs.Board

  @valid_attrs %{about: "some content", name: "some content"}
  @invalid_attrs %{}

  # test "changeset with valid attributes" do
  #   changeset = Board.changeset(%Board{}, @valid_attrs)
  #   assert changeset.valid?
  # end
  #
  # test "changeset with invalid attributes" do
  #   changeset = Board.changeset(%Board{}, @invalid_attrs)
  #   refute changeset.valid?
  # end
end
