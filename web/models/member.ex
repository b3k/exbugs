defmodule Exbugs.Member do
  use Exbugs.Web, :model
  use Arc.Ecto.Model
  import Ecto.Query

  alias Exbugs.{Repo, Member}

  schema "members" do
    belongs_to :company, Exbugs.Company
    belongs_to :user, Exbugs.User

    field :mark, :string, default: "member"
    field :role, :string

    timestamps
  end

  @create_required_fields ~w(user_id company_id role)
  @create_optional_fields ~w()

  def create_changeset(model, params \\ :empty) do
    model
    |> cast(params, @create_required_fields, @create_optional_fields)
    |> validate_inclusion(:role, ~w(member admin))
  end

  @update_required_fields ~w(role)
  @update_optional_fields ~w(mark)

  def update_changeset(model, params \\ :empty) do
    model
    |> cast(params, @update_required_fields, @update_optional_fields)
    |> validate_inclusion(:role, ~w(member admin))
    |> validate_length(:mark, max: 25)
  end

  def select_and_limit(company, limit) do
    query = from m in Member,
      where: m.company_id == ^company.id,
      limit: ^limit
    Repo.all(query) |> Repo.preload([:user])
  end
end
