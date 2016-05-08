defmodule Exbugs.UserTest do
  use Exbugs.ModelCase

  alias Exbugs.User

  import Exbugs.Factory

  @create_valid_attrs %{email: "email@test.com", username: "username", password: "password"}
  @create_invalid_attrs %{email: "email", username: "user name", password: "password"}

  @update_valid_attrs %{full_name: "James Bond", location: "NY", about: "Agent 007"}
  @update_invalid_attrs %{full_name: "James Boooooooooooooooooooooooooooooooooooooooooooooooooond"}

  test "create changeset with valid attributes" do
    changeset = User.create_changeset(%User{}, @create_valid_attrs)
    assert changeset.valid?
  end

  test "create changeset with invalid attributes" do
    changeset = User.create_changeset(%User{}, @create_invalid_attrs)
    refute changeset.valid?
  end

  test "update changeset with valid attributes" do
    changeset = User.update_changeset(%User{}, @update_valid_attrs)
    assert changeset.valid?
  end

  test "update changeset with invalid attributes" do
    changeset = User.update_changeset(%User{}, @update_invalid_attrs)
    refute changeset.valid?
  end

  test "has user" do
    user = create(:user)
    assert User.has_user?(user)
  end
end
