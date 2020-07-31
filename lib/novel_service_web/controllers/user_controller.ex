defmodule NovelServiceWeb.UserController do
  use NovelServiceWeb, :controller

  alias NovelService.Accounts
  alias NovelService.Accounts.User
  alias NovelService.Accounts.Guardian

  plug :is_authorized when action in [:edit, :update, :delete]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    IO.inspect(user)
    render(conn, "show.html", user: user)
  end

  def edit(conn, _) do
    changeset = Accounts.change_user(conn.assigns.current_user)
    render(conn, "edit.html", user: conn.assigns.current_user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user
    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, _) do
    {:ok, _user} = Accounts.delete_user(conn.assigns.current_user)

    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp is_authorized(conn, _) do
    current_user = Accounts.current_user(conn)
    if current_user.id == String.to_integer(conn.params["id"]) do
      assign(conn, :current_user, current_user)
    else
      conn
      |> put_flash(:error, "You can't modify that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def mypage(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    IO.inspect(user)
    render(conn, "mypage.html", user: user)
  end
end
