defmodule Exbugs.User do
  use Exbugs.Web, :model
  use Arc.Ecto.Model

  @default_language "en"

  schema "users" do
    has_many :members, Exbugs.Member, on_delete: :delete_all
    has_many :companies, Exbugs.Company, on_delete: :delete_all

    field :username, :string
    field :email, :string
    field :full_name, :string
    field :about, :string
    field :location, :string
    field :avatar, Exbugs.Avatar.Type
    field :language, :string, default: @default_language
    field :crypted_password, :string
    field :password, :string, virtual: true
    field :role, :string

    timestamps
  end

  # For create action
  @create_required_fields ~w(username email password)
  @create_optional_fields ~w()

  def create_changeset(model, params \\ :empty) do
    model
    |> cast(params, @create_required_fields, @create_optional_fields)
    |> update_change(:username, &String.downcase/1)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:username)
    |> validate_length(:username, min: 2, max: 25)
    |> unique_constraint(:email)
    |> validate_length(:email, max: 100)
    |> validate_format(:email, ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
  end

  # For update action
  @update_required_fields ~w()
  @update_optional_fields ~w(full_name about location role)

  def update_changeset(user, params \\ %{}) do
    user
    |> cast(params, @update_required_fields, @update_optional_fields)
    |> cast_attachments(params, ~w(), ~w(avatar))
    |> validate_length(:full_name, max: 50)
    |> validate_length(:about, max: 250)
    |> validate_length(:location, max: 150)
    |> validate_inclusion(:role, ~w(user admin))
  end

  def has_user?(user) do
    case user do
      nil ->
        false
      user ->
        true
    end
  end

  def current_user_language(conn) do
    if logged_in?(conn) do
      current_user(conn).language
    else
      @default_language
    end
  end

  def change_role(user) do
    user
  end
end
