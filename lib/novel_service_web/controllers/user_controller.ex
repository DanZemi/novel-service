defmodule NovelServiceWeb.UserController do
  use NovelServiceWeb, :controller

  alias NovelService.Accounts
  alias NovelService.Accounts.User
  alias NovelService.Accounts.Guardian

  plug :is_authorized when action in [:edit, :update, :delete, :editpassword]

  # ユーザー一覧画面を表示
  def index(conn, params) do
    users = Accounts.list_users(params)
    render(conn, "index.html", users: users)
  end

  # ユーザー登録画面を表示
  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  # ユーザー作成
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

  # 特定のユーザー画面を表示
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  # ユーザー編集画面を表示
  def edit(conn, _) do
    changeset = Accounts.change_user(conn.assigns.current_user)
    render(conn, "edit.html", user: conn.assigns.current_user, changeset: changeset)
  end

  def editpass(conn, _) do
    changeset = Accounts.change_user(conn.assigns.current_user)
    render(conn, "editpass.html", user: conn.assigns.current_user, changeset: changeset)
  end

  # ユーザー情報の更新
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

  # ユーザーの削除
  def delete(conn, _) do
    {:ok, _user} = Accounts.delete_user(conn.assigns.current_user)

    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "退会が完了しました。")
    |> redirect(to: Routes.article_path(conn, :home))
  end

  # そのページを修正できるか
  defp is_authorized(conn, _) do
    current_user = Accounts.current_user(conn)

    if current_user.id == String.to_integer(conn.params["id"]) do
      assign(conn, :current_user, current_user)
    else
      conn
      |> put_flash(:error, "そのページを修正することはできません")
      |> redirect(to: Routes.article_path(conn, :home))
      |> halt()
    end
  end

  # マイページを表示
  def mypage(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    # 現在のページにアクセスできるか
    if Accounts.current_viewed?(conn, user.id) do
      render(conn, "mypage.html", user: user)
    else
      conn
      |> put_flash(:error, "そのページを修正することはできません")
      |> redirect(to: Routes.article_path(conn, :home))
      |> halt()
    end
  end

  # 自分の情報画面を表示
  def myinfo(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    if Accounts.current_viewed?(conn, user.id) do
      render(conn, "myinfo.html", user: user)
    else
      conn
      |> put_flash(:error, "そのページを修正することはできません")
      |> redirect(to: Routes.article_path(conn, :home))
      |> halt()
    end
  end

  # ユーザーの情報画面を表示
  def userinfo(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "userinfo.html", user: user)
  end
end
