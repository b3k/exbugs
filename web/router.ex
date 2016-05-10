defmodule Exbugs.Router do
  use Exbugs.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Exbugs.API do
    pipe_through :api

    get "/users/autocomplete", UserController, :autocomplete
  end

  scope "/", Exbugs do
    pipe_through [:browser, :browser_session]

    get "/", DashboardController, :index

    # Authentication
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete
    resources "/registrations", RegistrationController, only: [:new, :create]

    # Companies
    get "/companies/my", CompanyController, :my

    resources "/companies", CompanyController, param: "name" do
      resources "/members", MemberController, except: [:show]
      resources "/boards", BoardController, except: [:index, :show], param: "name" do
        resources "/tickets", TicketController
      end
    end

    # Dashboard
    resources "/dashboard", DashboardController, only: [:index]

    # Users
    resources "/users", UserController, only: [:index]

    # Profile settings
    get "/settings/profile", Setting.ProfileController, :edit
    put "/settings/profile", Setting.ProfileController, :update
  end
end
