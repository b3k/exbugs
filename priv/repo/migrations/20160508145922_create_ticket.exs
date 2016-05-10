defmodule Exbugs.Repo.Migrations.CreateTicket do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :title, :string
      add :body, :string, size: 2000
      add :board_id, references(:boards)
      add :user_id, references(:users)
      timestamps
    end
  end
end
