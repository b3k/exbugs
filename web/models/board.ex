defmodule Exbugs.Board do
  use Exbugs.Web, :model

  import Exbugs.Gettext

  alias Exbugs.{Repo, Board}

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
    |> validate_format(:name, ~r/\A[A-Za-z0-9_.-]+\z/)
    |> validate_exclusion(:name, ~w(new create update edit delete))
    |> validate_length(:name, min: 2, max: 50)
    |> validate_length(:about, max: 150)
    |> validate_name_unique(:name, message: dgettext("errors", "has already been taken"))
  end

  defp validate_name_unique(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      name = changeset.params["name"] |> String.downcase
      board = Repo.get_by(Board, %{company_id: changeset.model.company_id, name: name})

      case board do
        nil -> []
        _board -> [{field, options[:message]}]
      end
    end
  end
end
