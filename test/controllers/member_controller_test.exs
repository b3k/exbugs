defmodule Exbugs.MemberControllerTest do
  use Exbugs.ConnCase

  alias Exbugs.{Repo, Member, User}
  import Exbugs.Factory

  setup do
    user = create(:user)
    company = create(:company, user: user)
    member = create(:member, user: user, company: company, role: "creator")
    {:ok, conn: conn(), user: user, company: company, member: member}
  end

  test "lists all entries on index", %{conn: conn, user: user, company: company} do
    conn = guardian_login(user)
    |> get(company_member_path(conn, :index, company.name))

    assert html_response(conn, 200) =~ company.name <> " - Members"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, user: user, company: company} do
    another_user = create(:user)

    conn = guardian_login(user)
    |> post(company_member_path(conn, :create, company.name), member: %{username: another_user.username})

    assert redirected_to(conn) == company_path(conn, :show, company.name)
    assert Repo.get_by(Member, user_id: another_user.id)
  end

  test "renders form for editing chosen resource", %{conn: conn, user: user, company: company} do
    member = create(:member, company: company, user: create(:user))
    |> Repo.preload(:user)

    conn = guardian_login(user)
    |> get(company_member_path(conn, :edit, company.name, member))

    assert html_response(conn, 200) =~ "Edit " <> member.user.username
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user, company: company} do
    another_user = create(:user)
    member = create(:member, user: another_user, company: company)

    conn = guardian_login(user)
    |> put(company_member_path(conn, :update, company.name, member), member: %{mark: "mark", role: "member"})

    assert redirected_to(conn) == company_member_path(conn, :index, company.name)
    assert Repo.get_by(Member, user_id: another_user.id)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user, company: company} do
    another_user = create(:user)
    member = create(:member, user: another_user, company: company)

    conn = guardian_login(user)
    |> put(company_member_path(conn, :update, company.name, member), member: %{mark: "some loooooooooooooooooong mark", role: "member"})

    assert html_response(conn, 200) =~ "Edit " <> another_user.username
  end

  test "deletes chosen resource", %{conn: conn, user: user, company: company} do
    another_user = create(:user)
    member = create(:member, user: another_user, company: company)

    conn = guardian_login(user)
    |> delete(company_member_path(conn, :delete, company.name, member))

    assert redirected_to(conn) == company_member_path(conn, :index, company.name)
    refute Repo.get(Member, member.id)
  end
end
