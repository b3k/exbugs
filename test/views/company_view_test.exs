defmodule Exbugs.CompanyViewTest do
  use Exbugs.ConnCase, async: true
  use Phoenix.HTML

  import Exbugs.Factory

  alias Exbugs.CompanyView

  test "show name" do
    company = create(:company, public_name: "Google inc", user: create(:user))
    another_company = create(:company, user: create(:user))

    assert "Google inc" = CompanyView.show_name(company)
    assert CompanyView.show_name(company, :full) == "Google inc (#{company.name})"
    assert CompanyView.show_name(another_company) == another_company.name
  end

  test "show url" do
    company = create(:company, url: "http://livecoding.tv", user: create(:user))
    another_company = create(:company, user: create(:user))

    assert CompanyView.show_url(company) == link(" #{company.url}", to: company.url)
    assert CompanyView.show_url(another_company) == nil
  end
end
