defmodule Exbugs.Repo.Migrations.CreateMember do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :user_id, references(:users)
      add :company_id, references(:companies)
      timestamps
    end

  end
end
