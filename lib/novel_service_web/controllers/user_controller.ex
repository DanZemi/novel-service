defmodule NovelServiceWeb.UserController do
  use NovelServiceWeb, :controller

  alias NovelService.Accounts
  alias NovelService.Accounts.User
  alias NovelService.Accounts.Guardian

  plug :is_authorized when action in [:edit, :update, :delete, :editpassword]

  def index(conn, params) do
    users = Accounts.list_users(params)
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
        |> put_flash(:info, "アカウント登録が完了しました。")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: Routes.article_path(conn, :home))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
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
        |> put_flash(:info, "ユーザー情報が更新されました。")
        |> redirect(to: Routes.user_path(conn, :myinfo, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, _) do
    {:ok, _user} = Accounts.delete_user(conn.assigns.current_user)

    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "退会が完了しました。")
    |> redirect(to: Routes.article_path(conn, :home))
  end

  defp is_authorized(conn, _) do
    current_user = Accounts.current_user(conn)

    if current_user.id == String.to_integer(conn.params["id"]) do
      assign(conn, :current_user, current_user)
    else
      conn
      |> put_flash(:error, "You can't modify that page")
      |> redirect(to: Routes.article_path(conn, :home))
      |> halt()
    end
  end

  def mypage(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "mypage.html", user: user)
  end

  def myinfo(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "myinfo.html", user: user)
  end

  def userinfo(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "userinfo.html", user: user)
  end
end
