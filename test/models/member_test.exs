defmodule Exbugs.MemberTest do
  use Exbugs.ModelCase

  alias Exbugs.Member

  import Exbugs.Factory

  test "create changeset with valid attributes" do
    user = create(:user)
    company = create(:company, user: user)

    changeset = Member.create_changeset(%Member{}, %{user_id: user.id, company_id: company.id, role: "member"})
    assert changeset.valid?
  end

  test "create changeset with invalid attributes" do
    user = create(:user)
    company = create(:company, user: user)

    changeset = Member.create_changeset(%Member{}, %{user_id: user.id, company_id: company.id, role: "creator"})
    refute changeset.valid?
  end

  test "update changeset with valid attributes" do
    user = create(:user)
    company = create(:company, user: user)
    member = create(:member, company: company, user: user)

    changeset = Member.update_changeset(member, %{role: "member", mark: "Release manager"})
    assert changeset.valid?
  end

  test "update changeset with invalid attributes" do
    user = create(:user)
    company = create(:company, user: user)
    member = create(:member, company: company, user: user)

    changeset = Member.update_changeset(member, %{role: "creator", mark: "Release manager"})
    refute changeset.valid?
  end

  test "select and limit" do
    user = create(:user)
    company = create(:company, user: user)
    _member = create(:member, company: company, user: user)

    for _ <- 0..10 do
      user = create(:user)
      _member = create(:member, company: company, user: user)
    end

    assert 5 = Member.select_and_limit(company, 5) |> Enum.count
  end
end
