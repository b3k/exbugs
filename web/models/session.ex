defmodule Exbugs.Session do
  alias Exbugs.User

  def login(params, repo) do
    user = repo.get_by(User, email: String.downcase(params["email"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end

  def logged_in?(conn), do: !!current_user(conn)

  def current_user(conn) do
    user = Guardian.Plug.current_resource(conn)

    case user do
      user -> user
      _ -> nil
    end
  end
end
