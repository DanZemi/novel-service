defmodule NovelServiceWeb.SessionController do
  use NovelServiceWeb, :controller

  alias NovelService.Accounts
  alias NovelService.Accounts.{User, Guardian}

  # ログイン画面を表示
  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  # ログイン
  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    Accounts.authenticate_user(email, password)
    |> login_reply(conn)
  end

  # ログイン処理(成功)
  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "ようこそ")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
  end

  # ログイン処理(失敗)
  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end

  # ログアウト
  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "ログアウトしました。")
    |> redirect(to: Routes.article_path(conn, :home))
  end
end
