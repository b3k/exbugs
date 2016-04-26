defmodule Exbugs.CompanyController do
  use Exbugs.Web, :controller

  alias Exbugs.{Company, Member}

  import Exbugs.Abilities, only: [can_manage_company?: 2]
  import Exbugs.Redirects, only: [redirect_unless_signed_in: 2, redirect_unless: 2, redirect_if_private: 2]

  plug :redirect_unless_signed_in when not(action in [:index, :show])
  plug :redirect_if_private when not(action in [:index, :my, :new, :create])
  plug :scrub_params, "company" when action in [:create, :update]
  plug :authorize when not(action in [:index, :my, :show, :new, :create])

  def index(conn, params) do
    page = Company
      |> Company.ordered
      |> Company.public_only
      |> Repo.paginate(params)

    render conn, "index.html",
      page_title: dgettext("companies", "All companies"),
      companies: page.entries
  end

  def my(conn, params) do
    page = Company.user_companies(current_user(conn))
      |> Company.ordered
      |> Repo.paginate(params)

    render conn, "index.html",
      page_title: dgettext("companies", "My companies"),
      companies: page.entries
  end

  def new(conn, _params) do
    changeset = Company.create_changeset(%Company{})

    render conn, "new.html",
      page_title: dgettext("companies", "New company"),
      changeset: changeset
  end

  def create(conn, %{"company" => company_params}) do
    company = Ecto.Model.build(current_user(conn), :companies)
    changeset = Company.create_changeset(company, company_params)

    case Repo.insert(changeset) do
      {:ok, company} ->
        Company.add_member(company)

        conn
        |> put_flash(:info, gettext("%{attribute} created successfully", [attribute: "Company"]))
        |> redirect(to: company_path(conn, :index))

      {:error, changeset} ->
        render conn, "new.html",
          page_title: dgettext("companies", "New company"),
          changeset: changeset
    end
  end

  def show(conn, %{"name" => name}) do
    company = Repo.get_by!(Company, name: name)
      |> Repo.preload([:boards])

    query = Repo.all(assoc(company, :members), limit: 9)
    members = Repo.preload(query, [:user])

    member_changeset = Member.create_changeset(%Member{})

    render conn, "show.html",
      page_title: Exbugs.CompanyView.show_name(company, :full),
      company: company,
      members: members,
      boards: company.boards,
      member_changeset: member_changeset
  end

  def edit(conn, %{"name" => name}) do
    company = Repo.get_by!(Company, name: name)
    changeset = Company.update_changeset(company)

    render conn, "edit.html",
      page_title: dgettext("companies", "Company settings"),
      company: company,
      changeset: changeset
  end

  def update(conn, %{"name" => name, "company" => company_params}) do
    company = Repo.get_by!(Company, name: name)
    changeset = Company.update_changeset(company, company_params)

    case Repo.update(changeset) do
      {:ok, company} ->
        conn
        |> put_flash(:info, gettext("%{attribute} updated successfully", [attribute: "Company"]))
        |> redirect(to: company_path(conn, :show, company.name))
      {:error, changeset} ->
        render conn, "edit.html",
          page_title: dgettext("companies", "Company settings"),
          company: company,
          changeset: changeset
    end
  end

  def delete(conn, %{"name" => name}) do
    company = Repo.get_by!(Company, name: name)

    Repo.delete!(company)

    conn
    |> put_flash(:info, gettext("%{attribute} deleted successfully", [attribute: "Company"]))
    |> redirect(to: company_path(conn, :index))
  end

  defp authorize(conn, _params) do
    company = Repo.get_by(Company, name: conn.params["name"])
    redirect_unless(conn, can_manage_company?(current_user(conn), company))
  end
end
