defmodule Exbugs.Abilities do
  @moduledoc """
  Check permissions
  """

  alias Exbugs.{User, Company, Member}
  alias Exbugs.Repo

  import Ecto
  import Ecto.Query, only: [from: 1, from: 2]

  @privilege ["admin", "creator"]

  @doc """
  Manage companies (update, remove, etc)
  """
  def can_manage_company?(nil, _), do: false
  def can_manage_company?(user, company) do
    case Company.has_member?(company, user) do
      true ->
        member = Repo.get_by!(Member, user_id: user.id, company_id: company.id)

        cond do
          member.role == "creator" ->
            true
          user.role in @privilege ->
            true
          true ->
            false
        end

      _ -> false
    end
  end

  @doc """
  Manage members (add, remove, update, etc)
  """
  def can_manage_members?(nil, _), do: false
  def can_manage_members?(user, company) do
    case Company.has_member?(company, user) do
      true ->
        member = Repo.get_by!(Member, user_id: user.id, company_id: company.id)

        cond do
          member.role == "creator" ->
            true
          user.role == "creator" ->
            true
          true ->
            false
        end

      _ -> false
    end
  end
end
