defmodule Exbugs.Redirects do
  import Plug.Conn
  use Exbugs.Web, :controller

  alias Exbugs.Company

  def redirect_unless_signed_in(conn, _params) do
    case logged_in?(conn) do
      true ->
        conn
      false ->
        conn |> redirect(to: session_path(conn, :new))
    end
  end

  def redirect_if_signed_in(conn, _params) do
    case logged_in?(conn) do
      true ->
        conn |> redirect(to: session_path(conn, :new))
      false ->
        conn
    end
  end

  defp set_company(conn) do
    company_name = cond do
      Map.has_key?(conn.params, "name") ->
        conn.params["name"]
      true ->
        conn.params["company_name"]
    end

    company = Repo.get_by(Company, name: company_name)

    case company do
      nil ->
        conn
        |> put_flash(:error, gettext("Record is not exist"))
        |> redirect(to: "/")
      company ->
        company
    end
  end

  def redirect_if_private(conn, _params) do
    company = set_company(conn)

    case Company.public?(company) do
      true ->
        conn
      false ->
        case Company.has_member?(company, current_user(conn)) do
          true ->
            conn
          false ->
            conn
            |> put_flash(:error, gettext("company", "Access denied"))
            |> redirect(to: "/")
        end
    end
  end

  def redirect_unless(conn, true), do: conn
  def redirect_unless(conn, false), do: conn |> redirect(to: "/")
end
