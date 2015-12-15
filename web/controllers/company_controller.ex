defmodule Exbugs.CompanyController do
  use Exbugs.Web, :controller
  alias Exbugs.Company
  import Exbugs.Redirects, only: [redirect_unless_signed_in: 2]

  plug :redirect_unless_signed_in when not(action in [:index, :show])
  plug :scrub_params, "company" when action in [:create, :update]

  def index(conn, params) do
    page = Company
    |> Company.ordered
    |> Repo.paginate(params)

    render conn, "index.html",
      page_title: dgettext("companies", "All companies"),
      companies: page.entries
  end

  def new(conn, _params) do
    changeset = Company.changeset(%Company{})

    render conn, "new.html",
      page_title: dgettext("companies", "New company"),
      changeset: changeset
  end

  def create(conn, %{"company" => company_params}) do
    company = Ecto.Model.build(current_user(conn), :companies)
    changeset = Company.changeset(company, company_params)

    case Repo.insert(changeset) do
      {:ok, _company} ->
        conn
        |> put_flash(:info, "Company created successfully.")
        |> redirect(to: company_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html",
          page_title: dgettext("companies", "New company"),
          changeset: changeset
    end
  end

  def show(conn, %{"name" => name}) do
    company = Repo.get_by!(Company, name: name)
    render(conn, "show.html", company: company)
  end

  def edit(conn, %{"name" => name}) do
    company = Repo.get_by!(Company, name: name)
    changeset = Company.changeset(company)

    render conn, "edit.html",
      page_title: dgettext("companies", "Company settings"),
      company: company,
      changeset: changeset
  end

  def update(conn, %{"name" => name, "company" => company_params}) do
    company = Repo.get_by!(Company, name: name)
    changeset = Company.changeset(company, company_params)

    case Repo.update(changeset) do
      {:ok, company} ->
        conn
        |> put_flash(:info, "Company updated successfully.")
        |> redirect(to: company_path(conn, :show, company))
      {:error, changeset} ->
        render conn, "edit.html",
          page_title: dgettext("companies", "Company settings"),
          company: company,
          changeset: changeset
    end
  end

  def delete(conn, %{"name" => name}) do
    company = Repo.get_by!(Company, name: name)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(company)

    conn
    |> put_flash(:info, "Company deleted successfully.")
    |> redirect(to: company_path(conn, :index))
  end
end
