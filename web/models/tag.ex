defmodule Exbugs.Tag do
  use Exbugs.Web, :model

  import Exbugs.Gettext
  import Ecto.Query

  alias Exbugs.{Tag, Tagging, Repo}

  @tags_counts %{min: 2, max: 5}
  @tags_lengths %{min: 2, max: 25}

  schema "tags" do
    has_many :taggings, Exbugs.Tagging, on_delete: :delete_all
    field :name, :string

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 2, max: 25)
    |> unique_constraint(:name)
  end

  @doc """
  Select records by tag name

  ## Example:
      taggable(Exbugs.Ticket, "ticket_name") |> Repo.all
  """
  def taggable(module, tag) do
    module_name = module_to_string(module)
    query = Repo.get_by(Tag, name: tag)

    case query do
      nil -> []
      _ ->
        tag_id = query.id
        Tagging
          |> where([type: ^module_name, tag_id: ^tag_id])
          |> join(:inner, [tg], m in ^module, m.id == tg.tagging_id) |> select([_, m], m)
    end
  end

  @doc """
  Check exist tags for record

  ## Example:
      ticket = Repo.get(Exbugs.Ticket, 1)
      has_tags?(Exbugs.Ticket, ticket)
  """
  def has_tags?(module, tagging) do
    tagging_id = tagging.id
    module_name = module_to_string(module)

    taggings = Tagging
      |> where([type: ^module_name, tagging_id: ^tagging_id])
      |> Repo.all

    Enum.count(taggings) > 0
  end

  @doc """
  Getting tags list for record

  ## Example:
      ticket = Repo.get(Exbugs.Ticket, 1)
      tags_for(Exbugs.Ticket, ticket)
  """
  def tags_for(module, tagging) do
    tagging_id = tagging.id
    module_name = module_to_string(module)

    case has_tags?(module, tagging) do
      true ->
        Tagging
          |> where([type: ^module_name, tagging_id: ^tagging_id])
          |> Repo.all
          |> Repo.preload(:tag)
          |> Enum.map(&(&1.tag.name))
      false -> []
    end
  end

  @doc """
  Adding tags for records

  ## Example:
      ticket = Repo.get(Exbugs.Ticket, 1)
      Ticket.add_tags("ticket", ticket, "tag, tag2, tag3")
  """
  def add_tags(type, tagging, tags) do
    tagging_id = tagging.id
    tags = tags
      |> tags_to_list

    for tag <- tags do
      current_tag = case Repo.get_by(Tag, name: tag) do
        nil ->
          tag_changeset = Tag.changeset(%Tag{}, %{name: tag})

          case tag_changeset.valid? do
            true -> Repo.insert!(tag_changeset)
          end

        tag -> tag
      end

      tagging_changeset = Tagging.changeset(%Tagging{}, %{type: type, tag_id: current_tag.id, tagging_id: tagging_id})
      Repo.insert(tagging_changeset)
    end
  end

  @doc """
  Validate tags length
  """
  def validate_tags_length(model, field) do
    validate_change model, field, fn _, url ->
      tags_param = model.params[Atom.to_string(field)]
      tags = tags_to_list(tags_param) || []

      cond do
        has_short?(tags) ->
          [{field, dgettext("errors", "should be at least %{count} character(s)", [count: @tags_lengths.min])}]
        has_long?(tags) ->
          [{field, dgettext("errors", "should be at most %{count} character(s)", [count: @tags_kengths.max])}]
        true -> []
      end
    end
  end

 @doc """
 Validate tags count
 """
  def validate_tags_count(model, field) do
    validate_change model, field, fn _, url ->
      tags_param = model.params[Atom.to_string(field)]
      tags = tags_to_list(tags_param) || []

      cond do
        Enum.count(tags) > @tags_counts.max ->
          [{field, dgettext("errors", "should have at most %{count} item(s)", [count: @tags_counts.max])}]
        Enum.count(tags) < @tags_counts.min || Enum.count(tags) == 0 ->
          [{field, dgettext("errors", "should have at least %{count} item(s)", [count: @tags_counts.min])}]
        true -> []
      end
    end
  end

  defp tags_to_list(tags) do
    tags
    |> String.downcase
    |> String.split(",")
    |> Enum.uniq
    |> Enum.map(&(String.strip(&1)))
  end

  defp has_short?(tags) do
    short_tags = tags
      |> Enum.filter(&(String.length(&1) < @tags_lengths.min))

    Enum.count(short_tags) > 0
  end

  defp has_long?(tags) do
    long_tags = tags
      |> Enum.filter(&(String.length(&1) > @tags_lengths.max))

    Enum.count(long_tags) > 0
  end

  defp module_to_string(module) do
    "#{module}"
    |> String.split(".")
    |> Enum.drop(2)
    |> Enum.join("")
    |> String.downcase
  end
end
