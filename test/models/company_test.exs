defmodule Exbugs.CompanyTest do
  use Exbugs.ModelCase

  alias Exbugs.Company

  import Exbugs.Factory

  @create_valid_attrs %{name: "companyname", visible: 1, user: create(:user)}
  @create_invalid_attrs %{name: "invalid name", visible: 666, user: create(:user)}

  @update_valid_attrs %{name: "companyname", about: "about the company", url: "http://test.com", visible: 0}
  @update_invalid_attrs %{name: "company name", url: "some text"}

  test "create changeset with valid attributes" do
    changeset = Company.create_changeset(%Company{}, @create_valid_attrs)
    assert changeset.valid?
  end

  test "create changeset with invalid attributes" do
    changeset = Company.create_changeset(%Company{}, @create_invalid_attrs)
    refute changeset.valid?
  end

  test "update changeset with valid attributes" do
    changeset = Company.update_changeset(%Company{}, @update_valid_attrs)
    assert changeset.valid?
  end

  test "update changeset with invalid attributes" do
    changeset = Company.update_changeset(%Company{}, @update_invalid_attrs)
    refute changeset.valid?
  end

  test "user companies" do
    user = create(:user)
    another_user = create(:user)

    for _ <- 0..2 do
      company = create(:company, user: user)
      create(:member, user: user, company: company)
    end

    assert 2 = Company.user_companies(user, 2) |> Enum.count
    assert 3 = Company.user_companies(user) |> Repo.all |> Enum.count
    assert 0 = Company.user_companies(another_user) |> Repo.all |> Enum.count
  end

  test "has member" do
    user = create(:user)
    another_user = create(:user)

    company = create(:company, user: user)
    _member = create(:member, company: company, user: user)

    assert Company.has_member?(company, user)
    refute Company.has_member?(company, another_user)
  end

  test "add member" do
    user = create(:user)
    another_user = create(:user)
    company = create(:company, user: user)

    Company.add_member(company)
    assert Company.has_member?(company, user)

    Company.add_member(company, another_user)
    assert Company.has_member?(company, another_user)
  end

  test "public?" do
    company = create(:company, user: create(:user), visible: 1)
    another_company = create(:company, user: create(:user), visible: 0)

    assert Company.public?(company)
    refute Company.public?(another_company)
  end

  test "members count" do
    company = create(:company, user: create(:user))

    for _ <- 0..9 do
      create(:member, user: create(:user), company: company)
    end

    assert 10 = Company.members_count(company)
  end
end
