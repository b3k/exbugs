defmodule Exbugs.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, size: 100, unique: true
      add :username, :string, size: 50, unique: true
      add :crypted_password, :string
      add :full_name, :string
      add :location, :string
      add :about, :string, size: 250
      add :avatar, :string
      add :language, :string, size: 2
      timestamps
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
  end
end
