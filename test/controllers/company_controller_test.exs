defmodule Exbugs.CompanyControllerTest do
  use Exbugs.ConnCase

  alias Exbugs.{Company, Repo}
  import Exbugs.Factory

  @valid_attrs %{name: "name", visible: 1}
  @invalid_attrs %{name: "name with spaces", visible: 666}

  setup do
    user = create(:user)
    {:ok, conn: conn(), user: user}
  end

  test "lists all entries on index", %{conn: conn} do
    _company = create(:company, user: create(:user))
    conn = get conn, company_path(conn, :index)
    assert html_response(conn, 200) =~ "All companies"
  end

  test "renders for my page", %{conn: conn, user: user} do
    conn = guardian_login(user)
    |> get(company_path(conn, :my))

    assert html_response(conn, 200) =~ "My companies"
  end

  test "renders form for new resources", %{conn: conn, user: user} do
    conn = guardian_login(user)
    |> get(company_path(conn, :new))

    assert html_response(conn, 200) =~ "New company"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, user: user} do
    conn = guardian_login(user)
    |> post(company_path(conn, :create), company: @valid_attrs)

    assert redirected_to(conn) == company_path(conn, :index)
    assert Repo.get_by(Company, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: user} do
    conn = guardian_login(user)
    |> post(company_path(conn, :create), company: @invalid_attrs)

    assert html_response(conn, 200) =~ "New company"
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    company = create(:company, user: user)
    conn = get conn, company_path(conn, :show, company.name)
    assert html_response(conn, 200) =~ company.name
  end

  test "renders form for editing chosen resource", %{conn: conn, user: user} do
    company = create(:company, user: user)
    _member = create(:member, company: company, user: user, role: "creator")

    conn = guardian_login(user)
    |> get(company_path(conn, :edit, company.name))

    assert html_response(conn, 200) =~ "Company settings"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    company = create(:company, user: user)
    _member = create(:member, company: company, user: user, role: "creator")

    conn = guardian_login(user)
    |> put(company_path(conn, :update, company.name), company: %{name: company.name, visible: company.visible})

    assert redirected_to(conn) == company_path(conn, :show, company.name)
    assert Repo.get_by(Company, name: company.name)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    company = create(:company, user: user)
    _member = create(:member, company: company, user: user, role: "creator")

    conn = guardian_login(user)
    |> put(company_path(conn, :update, company.name), company: @invalid_attrs)

    assert html_response(conn, 200) =~ "Company settings"
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    company = create(:company, user: user)
    _member = create(:member, company: company, user: user, role: "creator")

    conn = guardian_login(user)
    |> delete(company_path(conn, :delete, company.name))

    assert redirected_to(conn) == company_path(conn, :index)
    refute Repo.get(Company, company.id)
  end
end
