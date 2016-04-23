defmodule Exbugs.Member do
  use Exbugs.Web, :model
  use Arc.Ecto.Model
  import Ecto.Query

  schema "members" do
    belongs_to :company, Exbugs.Company
    belongs_to :user, Exbugs.User
    field :mark, :string
    field :role, :string
    timestamps
  end

  @create_required_fields ~w()
  @create_optional_fields ~w()

  def create_changeset(model, params \\ :empty) do
    model
    |> cast(params, @create_required_fields, @create_optional_fields)
  end

  @update_required_fields ~w()
  @update_optional_fields ~w(mark role)

  def update_changeset(model, params \\ :empty) do
    model
    |> cast(params, @update_required_fields, @update_optional_fields)
    |> validate_inclusion(:role, ~w(member admin))
    |> validate_length(:mark, max: 50)
  end
end
