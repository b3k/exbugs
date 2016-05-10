defmodule Exbugs.Ticket do
  use Exbugs.Web, :model

  alias Exbugs.{Tag, Repo, Board}

  import Exbugs.Gettext

  schema "tickets" do
    belongs_to :user, Exbugs.User
    belongs_to :board, Exbugs.Board

    field :title, :string
    field :body, :string
    field :tags, :string, virtual: true

    timestamps
  end

  @required_fields ~w(title body tags board_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> Tag.validate_tags_length(:tags)
    |> Tag.validate_tags_count(:tags)
    |> validate_board_id(:board_id)
  end

  defp validate_board_id(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      board = Repo.get(Board, changeset.params["board_id"])
      IO.inspect board
      case board do
        nil -> [{field, dgettext("errors", "invalid attribute")}]
        _board -> []
      end
    end
  end
end
