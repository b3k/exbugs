defmodule Exbugs.MemberController do
  use Exbugs.Web, :controller

  alias Exbugs.{Member, Company, User}

  import Exbugs.Abilities, only: [can_manage_members?: 2]
  import Exbugs.Redirects, only: [redirect_unless_signed_in: 2, redirect_unless: 2, redirect_if_private: 2]

  plug :redirect_unless_signed_in
  plug :redirect_if_private
  plug :authorize when not(action in [:index])
  plug :redirect_if_edit_himself when action in [:edit, :update, :delete]

  def index(conn, params) do
    company = Repo.get_by(Company, name: conn.params["company_name"])

    members = assoc(company, :members)
    query = from m in members, preload: [:user, :company]
    page = query |> Repo.paginate(params)

    render conn, "index.html",
      page_title: company.name <> " - "  <> dgettext("members", "Members"),
      members: page.entries
  end

  def create(conn, %{"member" => member_params}) do
    company = Repo.get_by(Company, name: conn.params["company_name"])
    user = Repo.get_by(User, username: member_params["username"])

    case user do
      nil ->
        conn
        |> put_flash(:error, dgettext("members", "User is not exists or already in members list"))
        |> redirect(to: company_path(conn, :show, company.name))
      user ->
        case Company.add_member(company, user) do
          {:ok, _} ->
            conn
            |> put_flash(:info, gettext("%{attribute} added successfully", [attribute: "Member"]))
            |> redirect(to: company_path(conn, :show, company.name))
          false ->
            conn
            |> put_flash(:error, dgettext("members", "User is not exists or already in members list"))
            |> redirect(to: company_path(conn, :show, company.name))
        end
    end
  end

  def edit(conn, %{"id" => id}) do
    query = Repo.get!(Member, id)
    member = Repo.preload(query, [:company, :user])

    changeset = Member.update_changeset(member)

    render conn, "edit.html",
      page_title: gettext("Edit") <> " " <> member.user.username,
      member: member,
      changeset: changeset
  end

  def update(conn, %{"id" => id, "member" => member_params}) do
    query = Repo.get!(Member, id)
    member = Repo.preload(query, [:company, :user])

    changeset = Member.update_changeset(member, member_params)

    case Repo.update(changeset) do
      {:ok, member} ->
        conn
        |> put_flash(:info, gettext("%{attribute} updated successfully", [attribute: "Member"]))
        |> redirect(to: company_member_path(conn, :index, member.company.name))
      {:error, changeset} ->
        render conn, "edit.html",
          page_title: gettext("Edit") <> " " <> member.user.username,
          member: member,
          changeset: changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    query = Repo.get!(Member, id)
    member = Repo.preload(query, [:company])

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(member)

    conn
    |> put_flash(:info, gettext("%{attribute} deleted successfully", [attribute: "Member"]))
    |> redirect(to: company_member_path(conn, :index, member.company.name))
  end

  defp authorize(conn, _params) do
    company = Repo.get_by(Company, name: conn.params["company_name"])
    redirect_unless(conn, can_manage_members?(current_user(conn), company))
  end

  defp redirect_if_edit_himself(conn, _params) do
    id = String.to_integer(conn.params["id"])
    member = Repo.get(Member, id)
    user = Repo.get(User, member.user_id)

    redirect_unless(conn, current_user(conn).id != user.id)
  end
end
