defmodule NovelService.Novel.Article do
  use Ecto.Schema
  import Ecto.Changeset
  alias NovelService.Accounts.User

  schema "articles" do
    field :content, :string
    field :title, :string
    field :views, :integer, default: 0

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end
