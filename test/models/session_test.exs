ExUnit.start

defmodule Exbugs.SessionTest do
  use ExUnit.Case, async: true

  alias Exbugs.Session

  import Exbugs.Factory

  test "login when user is exists" do
    user = create(:user)
    assert {:ok, _user} = Session.login(%{"email" => user.email, "password" => "password"})
  end

  test "login when user in not exists" do
    assert :error = Session.login(%{"email" => "fake@email.com", "password" => "password"})
  end
end
