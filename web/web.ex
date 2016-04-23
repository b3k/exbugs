defmodule Exbugs.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Exbugs.Web, :controller
      use Exbugs.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]

      import Exbugs.Session, only: [current_user: 1, logged_in?: 1]
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias Exbugs.Repo

      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]

      import Exbugs.Router.Helpers
      import Exbugs.Session, only: [current_user: 1, logged_in?: 1]

      import Exbugs.User, only: [current_user_language: 1]
      import Exbugs.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"
      use Phoenix.HTML

      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]
      import Exbugs.Session, only: [current_user: 1, logged_in?: 1]

      import Exbugs.User, only: [current_user_language: 1]
      import Exbugs.HelperMethods

      import Exbugs.Gettext
      import Exbugs.Abilities

      import Exbugs.Router.Helpers
      import Exbugs.ErrorHelpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Exbugs.Repo

      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
