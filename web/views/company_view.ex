defmodule Exbugs.CompanyView do
  use Exbugs.Web, :view
  import Exbugs.Company, only: [members_count: 1]

  def members_link(conn, company) do
    link content_tag(
      :span,

      content_tag(
        :span,
        "#{members_count(company)}",
        class: "span glyphicon glyphicon-user"
      ),

      class: "label label-primary",
      title: dgettext("companies", "Members")
     ), to: company_member_path(conn, :index, company.name)
  end

  def show_name(company, :full) do
    case company.public_name do
      nil -> show_name(company)
      _ -> show_name(company) <> " (#{company.name})"
    end
  end

  def show_name(company) do
    case company.public_name do
      nil -> company.name
      _ -> company.public_name
    end
  end

  def show_url(company) do
    case company.url do
      nil -> nil
      _ ->
        link " " <> company.url, to: company.url
    end
  end
end
