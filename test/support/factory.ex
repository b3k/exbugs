defmodule Exbugs.Factory do
  use ExMachina.Ecto, repo: Exbugs.Repo

  alias Exbugs.{User, Company, Board, Member, Ticket}

  def factory(:user) do
    %User{
      email: sequence(:email, &"me-#{&1}@foo.com"),
      username: sequence(:username, &"user#{&1}"),
      crypted_password: Comeonin.Bcrypt.hashpwsalt("password"),
      role: "user"
    }
  end

  def factory(:company) do
    %Company{
      name: sequence(:name, &"company#{&1}"),
      visible: 1,
      user: build(:user)
    }
  end

  def factory(:member) do
    %Member{
      user: build(:user),
      company: build(:company),
      role: "member"
    }
  end

  def factory(:board) do
    %Board{
      name: sequence(:name, &"boardcompany#{&1}"),
      company: build(:company)
    }
  end

  def factory(:ticket) do
    %Ticket{
      title: "Ticket title",
      body: "Ticket body",
      board: build(:board),
      user: build(:user)
    }
  end
end
