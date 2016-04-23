defmodule Exbugs.Repo.Migrations.CreateCompany do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :public_name, :string
      add :about, :string
      add :url, :string
      add :logo, :string
      add :location, :string
      add :visible, :integer
      add :user_id, references(:users)

      timestamps
    end

    create unique_index(:companies, [:name])
  end
end
