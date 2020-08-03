defmodule NovelServiceWeb.ArticleController do
  use NovelServiceWeb, :controller

  alias NovelService.Novel
  alias NovelService.Novel.Article
  alias NovelService.Accounts
  alias NovelService.Accounts.Guardian

  plug :is_authorized when action in [:edit, :update, :delete]

  def index(conn, _params) do
    articles = Novel.list_articles()
    render(conn, "index.html", articles: articles)
  end

  def new(conn, _params) do
    changeset = Novel.change_article(%Article{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    case Novel.create_article(Guardian.Plug.current_resource(conn), article_params) do
      {:ok, article} ->
        Novel.inc_have_articles(article)
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: Routes.article_path(conn, :show, article))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => hash_id}) do
    article =
      hash_id
      |> Novel.get_article!()
      |> Novel.inc_page_views()
    render(conn, "show.html", article: article)
  end

  def mynovelslist(conn, %{"id" => hash_id}) do
    article = Novel.get_article!(hash_id)
    render(conn, "mynovelslist.html", article: article)
  end

  def edit(conn, _) do
    article = conn.assigns.article
    changeset = Novel.change_article(article)
    render(conn, "edit.html", article: article, changeset: changeset)
  end

  def update(conn, %{"article" => article_params}) do
    article = conn.assigns.article

    case Novel.update_article(article, article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: Routes.article_path(conn, :show, article))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", article: article, changeset: changeset)
    end
  end

  def delete(conn, _) do
    article = conn.assigns.article
    {:ok, _article} = Novel.delete_article(article)
    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: Routes.article_path(conn, :index))
  end

  defp is_authorized(conn, _) do
    current_user = Accounts.current_user(conn)
    article = Novel.get_article!(conn.params["id"])
    if current_user.id == article.user.id do
      assign(conn, :article, article)
    else
      conn
      |> put_flash(:error, "You can't modify that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
