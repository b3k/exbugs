defmodule Exbugs.Company do
  use Exbugs.Web, :model
  use Arc.Ecto.Model
  import Ecto.Query
  alias Exbugs.{Member, User}

  schema "companies" do
    has_many :members, Exbugs.Member, on_delete: :delete_all
    has_many :boards, Exbugs.Board, on_delete: :delete_all

    belongs_to :user, Exbugs.User

    field :name, :string
    field :public_name, :string
    field :about, :string
    field :url, :string
    field :location, :string
    field :logo, Exbugs.Logo.Type
    field :visible, :integer

    timestamps
  end

  @create_required_fields ~w(name visible)
  @create_optional_fields ~w()

  def create_changeset(model, params \\ :empty) do
    model
    |> cast(params, @create_required_fields, @create_optional_fields)
    |> update_change(:name, &String.downcase/1)
    |> unique_constraint(:name)
    |> validate_length(:name, min: 1, max: 50)
    |> validate_format(:name, ~r/\A[A-Za-z0-9_.-]+\z/)
    |> validate_exclusion(:name, ~w(new create update edit delete))
    |> validate_number(:visible, greater_than: -1, less_than: 2)
  end

  # For update action
  @update_required_fields ~w(visible)
  @update_optional_fields ~w(url about location public_name)

  def update_changeset(user, params \\ %{}) do
    user
    |> cast(params, @update_required_fields, @update_optional_fields)
    |> cast_attachments(params, ~w(), ~w(logo))
    |> validate_length(:full_name, max: 50)
    |> validate_length(:about, max: 250)
    |> validate_length(:location, max: 150)
  end

  def add_member(company) do
    role = cond do
      members_count(company) == 0 ->
        "creator"
      true ->
        "member"
    end

    Exbugs.Repo.insert(%Member{company_id: company.id, user_id: company.user_id, role: role})
  end

  def add_member(company, user) do
    case {has_member?(company, user), User.has_user?(user)} do
      {false, true} ->
        Exbugs.Repo.insert(%Member{company_id: company.id, user_id: user.id, role: "member"})
      _ ->
        false
    end
  end

  def ordered(companies) do
    companies |> order_by(desc: :name)
  end

  def public?(company) do
    company.visible == 1
  end

  def has_member?(company, user) do
    member = Exbugs.Repo.get_by(assoc(company, :members), user_id: user.id)

    case member do
      nil ->
        false
      member ->
        true
    end
  end

  def public_only(company) do
    company |> where(visible: 1)
  end

  def members_count(company) do
    Exbugs.Repo.all(assoc(company, :members)) |> Enum.count
  end

  def show_name(company) do
    case company.public_name do
      nil ->
        company.name
      _ ->
        "#{company.public_name} (#{company.name})"
    end
  end
end
