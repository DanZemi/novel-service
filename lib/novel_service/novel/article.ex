defmodule NovelService.Novel.Article do
  use Ecto.Schema
  import Ecto.Changeset
  alias NovelService.Accounts.User
  @primary_key {:hash_id, :string, []}
  @derive {Phoenix.Param, key: :hash_id}

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
    |> validate_required([:title, :content], message: "空白になっています")
  end
end
