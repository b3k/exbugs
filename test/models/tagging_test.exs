defmodule Exbugs.TaggingTest do
  use Exbugs.ModelCase

  alias Exbugs.Tagging

  @valid_attrs %{tag_id: 42, tagging_id: 42, type: "ticket"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tagging.changeset(%Tagging{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tagging.changeset(%Tagging{}, @invalid_attrs)
    refute changeset.valid?
  end
end
