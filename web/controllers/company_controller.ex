defmodule Exbugs.CompanyController do
  use Exbugs.Web, :controller
  alias Exbugs.Company

  plug :scrub_params, "company" when action in [:create, :update]

  def index(conn, _params) do
    company = Repo.all(Company)
    render(conn, "index.html", company: company)
  end

  def new(conn, _params) do
    changeset = Company.changeset(%Company{})

    conn
    |> assign(:changeset, changeset)
    |> assign(:page_title, dgettext("company", "New company"))
    |> render "new.html"
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
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    company = Repo.get!(Company, id)
    render(conn, "show.html", company: company)
  end

  def edit(conn, %{"id" => id}) do
    company = Repo.get!(Company, id)
    changeset = Company.changeset(company)
    render(conn, "edit.html", company: company, changeset: changeset)
  end

  def update(conn, %{"id" => id, "company" => company_params}) do
    company = Repo.get!(Company, id)
    changeset = Company.changeset(company, company_params)

    case Repo.update(changeset) do
      {:ok, company} ->
        conn
        |> put_flash(:info, "Company updated successfully.")
        |> redirect(to: company_path(conn, :show, company))
      {:error, changeset} ->
        render(conn, "edit.html", company: company, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    company = Repo.get!(Company, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(company)

    conn
    |> put_flash(:info, "Company deleted successfully.")
    |> redirect(to: company_path(conn, :index))
  end
end
