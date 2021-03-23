defmodule NovelService.Novel do
  @moduledoc """
  The Novel context.
  """

  import Ecto.Query, warn: false
  alias NovelService.Repo
  alias Argon2
  alias NovelService.Novel.Article
  alias NovelService.Accounts.User

  @doc """
  Returns the list of articles.
  全ての小説をデータベースから持ってくる

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles(params) do
    search_term = get_in(params, ["query"])

    Article
    |> search(search_term)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single article.
  一つの小説をデータベースから取得

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id) do
    Article
    |> Repo.get!(id)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a article.
  小説を作る

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(%User{} = user, attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Ecto.Changeset.put_change(:hash_id, put_pass_hash_id(user.id, user.have_articles))
    |> Repo.insert()
  end

  def put_pass_hash_id(user_id, count_articles) do
    hash_article_id = to_string(user_id) <> " " <> to_string(count_articles)
    Argon2.hash_pwd_salt(hash_article_id)
  end

  @doc """
  Updates a article.
  小説を更新する

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a article.
  小説をデータベースから削除する
  ## Examples

      iex> delete_article(article)
      {:ok, %Article{}}

      iex> delete_article(article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

      iex> change_article(article)
      %Ecto.Changeset{data: %Article{}}

  """
  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end

  def inc_page_views(%Article{} = article, nil) do
    {1, [%Article{views: views}]} =
      from(a in Article,
        where:
          a.hash_id ==
            ^article.hash_id,
        select: [:views]
      )
      |> Repo.update_all(inc: [views: 0])

    put_in(article.views, views)
  end

  def inc_page_views(%Article{} = article, %User{} = user) do
    if user.id != article.user_id do
      {1, [%Article{views: views}]} =
        from(a in Article, where: a.hash_id == ^article.hash_id, select: [:views])
        |> Repo.update_all(inc: [views: 1])

      put_in(article.views, views)
    else
      {1, [%Article{views: views}]} =
        from(a in Article, where: a.hash_id == ^article.hash_id, select: [:views])
        |> Repo.update_all(inc: [views: 0])

      put_in(article.views, views)
    end
  end

  def inc_have_articles(%Article{} = article) do
    article =
      article
      |> Repo.preload(:user)

    {1, [%User{have_articles: have_articles}]} =
      from(u in User, where: u.id == ^article.user_id, select: [:have_articles])
      |> Repo.update_all(inc: [have_articles: 1])

    put_in(article.user.have_articles, have_articles)
  end

  # def dec_have_articles(%Article{} = article) do
  #  article =
  #  article
  #  |> Repo.preload(:user)
  #  {1, [%User{have_articles: have_articles}]} =
  #    from(u in User, where: u.id == ^article.user_id, select: [:have_articles])
  #    |> Repo.update_all(inc: [have_articles: -1])
  #  put_in(article.user.have_articles, have_articles)
  # end

  def search(query, search_term) do
    wildcard_seach = "%#{search_term}%"

    from article in query,
      where: ilike(article.title, ^wildcard_seach),
      or_where: ilike(article.content, ^wildcard_seach)
  end

  def list_articles_rank do
    Article
    |> order_by(desc: :views)
    |> Repo.all()
    |> Repo.preload(:user)

    ##   |> Repo.paginate(page: 2, page_size: 5)
  end

  def list_articles_date do
    Article
    |> order_by(desc: :updated_at)
    |> Repo.all()
    |> Repo.preload(:user)
  end
end
