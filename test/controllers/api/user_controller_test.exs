defmodule Exbugs.API.UserControllerTest do
  use Exbugs.ConnCase

  import Exbugs.Factory

  test "autocomplete when not query" do
    conn = get(conn(), user_path(conn(), :autocomplete))
    assert 200 = conn.status
    assert ~s({"suggestions":[]}) = conn.resp_body
  end

  test "autocomplete when query is exists" do
    create(:user, username: "test")
    create(:user, username: "ten")

    conn = get(conn(), "/api/users/autocomplete?query=te")

    assert 200 = conn.status
    assert ~s({"suggestions":["test","ten"]}) = conn.resp_body
  end
end
