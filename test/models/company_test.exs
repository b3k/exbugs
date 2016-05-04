defmodule Exbugs.CompanyTest do
  use Exbugs.ModelCase

  alias Exbugs.Company

  @valid_attrs %{describe: "some content", logo: "some content", name: "some content", visible: 42}
  @invalid_attrs %{}

  # test "changeset with valid attributes" do
  #   changeset = Company.changeset(%Company{}, @valid_attrs)
  #   assert changeset.valid?
  # end
  #
  # test "changeset with invalid attributes" do
  #   changeset = Company.changeset(%Company{}, @invalid_attrs)
  #   refute changeset.valid?
  # end
end
