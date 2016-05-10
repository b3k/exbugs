defmodule Exbugs.Tagging do
  use Exbugs.Web, :model

  @available_modules ~w(ticket)

  schema "taggings" do
    belongs_to :tag, Exbugs.Tag

    field :type, :string
    field :tagging_id, :integer

    timestamps
  end

  @required_fields ~w(type tag_id tagging_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:type, @available_modules)
  end
end
