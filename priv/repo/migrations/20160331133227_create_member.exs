defmodule Exbugs.Repo.Migrations.CreateMember do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :mark, :string, size: 50
      add :user_id, references(:users)
      add :company_id, references(:companies)
      add :role, :string, default: "member"

      timestamps
    end
  end
end
