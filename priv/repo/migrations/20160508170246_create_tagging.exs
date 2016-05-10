defmodule Exbugs.Repo.Migrations.CreateTagging do
  use Ecto.Migration

  def change do
    create table(:taggings) do
      add :type, :string
      add :tag_id, references(:tags)
      add :tagging_id, :integer

      timestamps
    end

  end
end
