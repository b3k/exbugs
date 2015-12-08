defmodule Exbugs.Company do
  use Exbugs.Web, :model
  use Arc.Ecto.Model

  schema "companies" do
    has_many :members, Exbugs.Member
    belongs_to :user, Exbugs.User

    field :name, :string
    field :about, :string
    field :url, :string
    field :location, :string
    field :logo, Exbugs.Logo.Type
    field :visible, :integer

    timestamps
  end

  @required_fields ~w(name visible)
  @optional_fields ~w(about logo url)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:name)
    |> validate_length(:name, min: 1, max: 50)
    |> validate_format(:name, ~r/\A[A-Za-z0-9_.-]+\z/)
    |> validate_number(:visible, greater_than: -1, less_than: 2)
  end

  # For update action
  @update_required_fields ~w(visible)
  @update_optional_fields ~w(url about location)

  def changeset_update(user, params \\ %{}) do
    user
    |> cast(params, @update_required_fields, @update_optional_fields)
    |> cast_attachments(params, ~w(), ~w(logo))
    |> validate_length(:full_name, max: 50)
    |> validate_length(:about, max: 250)
    |> validate_length(:location, max: 150)
  end
end
