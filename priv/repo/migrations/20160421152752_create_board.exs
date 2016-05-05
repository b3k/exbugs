defmodule Exbugs.Repo.Migrations.CreateBoard do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :name, :string
      add :about, :string, size: 500
      add :company_id, references(:companies)

      timestamps
    end
  end
end
