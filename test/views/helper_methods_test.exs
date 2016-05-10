defmodule Exbugs.HelperMethodsTest do
  use Exbugs.ConnCase, async: true

  alias Exbugs.HelperMethods

  test "show attribute when upcace param isn't selected" do
    assert "Test attribute" = HelperMethods.show_attribute(:test_attribute)
  end

  test "show attribute when upcase param is selected" do
    assert "URL" = HelperMethods.show_attribute(:url, :upcase)
  end

  test "show tag link" do
    result = ~s(<a href="/tag?=test"><span class="span glyphicon glyphicon-tag">test </a>)
    assert result = HelperMethods.show_tag_link("test", "/")
  end
end
