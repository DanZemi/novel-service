defmodule NovelServiceWeb.Router do
  use NovelServiceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NovelServiceWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug NovelService.Accounts.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", NovelServiceWeb do
    pipe_through [:browser, :auth]

    live "/", PageLive, :index
    get "/signin", UserController, :new
    post "/signin", UserController, :create
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    delete "/logout", SessionController, :logout
    get "/novels", ArticleController, :index
    get "/novels/:id", ArticleController, :show
    get "/userlists", UserController, :index
    get "/userlists/:id", UserController, :show
  end

  scope "/", NovelServiceWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    resources "/users", UserController, except: [:new, :create, :index, :show]
    resources "/articles", ArticleController, except: [:index, :show]
    get "/mypage/:id", UserController, :mypage
    get "/mynovelslist/:id", ArticleController, :mynovelslist
  end

  # Other scopes may use custom stacks.
  # scope "/api", NovelServiceWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: NovelServiceWeb.Telemetry
    end
  end
end
