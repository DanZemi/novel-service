defmodule NovelServiceWeb.ArticleView do
  use NovelServiceWeb, :view
  alias NovelService.Accounts

  def current_user(conn) do
    Accounts.current_user(conn)
  end
end
