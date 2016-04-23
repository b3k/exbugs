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
end
