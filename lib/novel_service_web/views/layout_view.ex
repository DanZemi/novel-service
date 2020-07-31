defmodule NovelServiceWeb.LayoutView do
  use NovelServiceWeb, :view

  alias NovelService.Accounts.Guardian

  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end
end
