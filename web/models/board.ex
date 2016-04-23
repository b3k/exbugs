defmodule Exbugs.Board do
  use Exbugs.Web, :model

  schema "boards" do
    belongs_to :company, Exbugs.Company

    field :name, :string
    field :about, :string

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(about)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:name, &String.downcase/1)
    |> unique_constraint(:name)
    |> validate_format(:name, ~r/\A[A-Za-z0-9_.-]+\z/)
    |> validate_exclusion(:name, ~w(new create update edit delete))
    |> validate_length(:name, min: 2, max: 50)
    |> validate_length(:about, max: 150)
  end
end
