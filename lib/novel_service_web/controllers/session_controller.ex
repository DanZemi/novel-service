defmodule NovelServiceWeb.SessionController do
  use NovelServiceWeb, :controller

  alias NovelService.Accounts
  alias NovelService.Accounts.{User, Guardian}

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    Accounts.authenticate_user(email, password)
    |> login_reply(conn)
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "ようこそ")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end

end
