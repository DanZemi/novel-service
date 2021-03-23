defmodule NovelServiceWeb.ArticleController do
  use NovelServiceWeb, :controller

  alias NovelService.Novel
  alias NovelService.Novel.Article
  alias NovelService.Accounts
  alias NovelService.Accounts.Guardian

  plug :is_authorized when action in [:edit, :update, :delete]
  # 全ての小説をモデルから取得しレンダリングする
  def index(conn, params) do
    articles = Novel.list_articles(params)
    render(conn, "index.html", articles: articles)
  end

  # 小説をランキング形式でレンダリング

  def rank(conn, _params) do
    articles = Novel.list_articles_rank()
    render(conn, "rank.html", articles: articles)
  end

  # ホーム画面をレンダリング
  def home(conn, _params) do
    articles = Novel.list_articles_date()
    render(conn, "home.html", articles: articles)
  end

  # 新しい小説を作成する画面をレンダリング

  def new(conn, _params) do
    changeset = Novel.change_article(%Article{})
    render(conn, "new.html", changeset: changeset)
  end

  # 新しい小説を作成
  # 成功 -> 新しく作られた小説のページへ
  # 失敗 -> もう一度同じ画面に
  def create(conn, %{"article" => article_params}) do
    case Novel.create_article(Guardian.Plug.current_resource(conn), article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "投稿が完了しました。")
        |> redirect(to: Routes.article_path(conn, :show, article))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # 一つの小説を表示

  def show(conn, %{"id" => hash_id}) do
    article =
      hash_id
      |> Novel.get_article!()
      |> Novel.inc_page_views(Guardian.Plug.current_resource(conn))

    render(conn, "show.html", article: article)
  end

  # 自分の小説一覧
  def mynovellists(conn, params) do
    articles = Novel.list_articles(params)
    render(conn, "mynovellists.html", articles: articles)
  end

  # あらすじ
  def summary(conn, %{"id" => hash_id}) do
    article = Novel.get_article!(hash_id)
    render(conn, "summary.html", article: article)
  end

  # 小説を編集
  def edit(conn, _) do
    article = conn.assigns.article
    changeset = Novel.change_article(article)
    render(conn, "edit.html", article: article, changeset: changeset)
  end

  # 小説を更新
  # 成功 -> 更新した小説を表示
  # 失敗 -> もう一度編集画面へ
  def update(conn, %{"article" => article_params}) do
    article = conn.assigns.article

    case Novel.update_article(article, article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "編集が完了しました。")
        |> redirect(to: Routes.article_path(conn, :show, article))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", article: article, changeset: changeset)
    end
  end

  # 小説の削除

  def delete(conn, _) do
    article = conn.assigns.article
    {:ok, _article} = Novel.delete_article(article)

    conn
    |> put_flash(:info, "削除が完了しました。")
    |> redirect(to: Routes.user_path(conn, :mypage, Accounts.current_user(conn)))
  end

  # ログイン状態かの確認
  defp is_authorized(conn, _) do
    current_user = Accounts.current_user(conn)
    article = Novel.get_article!(conn.params["id"])

    if current_user.id == article.user.id do
      assign(conn, :article, article)
    else
      conn
      |> put_flash(:error, "このページは修正できません。")
      |> redirect(to: Routes.user_path(conn, :index))
      |> halt()
    end
  end
end
