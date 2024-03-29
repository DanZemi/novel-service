defmodule NovelService.Accounts.ErrorHandler do
  import Plug.Conn
  alias NovelServiceWeb.SessionController
  use NovelServiceWeb, :controller
  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_, _reason}, _opts) do
    # body = to_string(type)
    # conn
    # |> put_resp_content_type("text/plain")
    # |> send_resp(401, body)
    conn
    |> redirect(to: "/login")
  end
end
