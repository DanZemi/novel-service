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

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles do
    Article
    |> order_by(desc: :views)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single article.

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

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(%User{} = user, attrs \\ %{}) do
    %Article{}
    |> IO.inspect
    |> Article.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> IO.inspect
    |> Repo.insert()
    #|> case do
    #  {:ok, article} -> Ecto.Changeset.change(article, id: put_pass_idhash(Map.get(article, :id), user.id)) |> IO.inspect()
    #end
    |> IO.inspect

  end

  def put_pass_idhash(article_id, user_id) do
    hash_article_id = to_string(user_id) <> " " <> to_string(article_id)
    Argon2.hash_pwd_salt(hash_article_id)
  end

  #def idhash_change(%Article{} = article, %Article{id: id} = attrs) do
  #  IO.inspect(id)
  #  article
  #  |> Article.changeset(id)
  #  |> put_pass_idhash()
  #  |> IO.inspect
  #  |> Repo.update()
  #end
  @doc """
  Updates a article.

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

  def inc_page_views(%Article{} = article) do
    {1, [%Article{views: views}]} =
      from(a in Article, where: a.id == ^article.id, select: [:views])
      |> Repo.update_all(inc: [views: 1])
    put_in(article.views, views)
  end

end
