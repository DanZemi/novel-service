defmodule NovelService.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias NovelService.Novel.Article
  alias Argon2

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string
    field :have_articles, :integer, default: 0
    field :bio, :string, default: "よろしくお願いします。"
    field :user_link, :string
    has_many :articles, Article
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :bio, :user_link])
    |> validate_required([:name, :email, :password], message: "空白になっています")
    |> validate_length(:name, min: 2, message: "2文字以上にして下さい")
    # |> validate_format(:name, ~r/^[a-zA-Z0-9_-]$/, message: "使用できない文字が含まれています")
    |> unique_constraint(:email, message: "そのメールアドレスは既に登録されています")
    |> validate_format(:email, ~r/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i,
      message: "メールアドレスの形式が間違っています"
    )
    |> validate_format(:password, ~r/^(?=.*?[a-z])(?=.*?\d)[a-z\d]{8,100}$/i,
      message: "半角英数字それぞれ1文字以上含む8文字以上の文字にして下さい"
    )
    |> validate_confirmation(:password, message: "パスワードと一致しません")
    |> put_pass_hash()
  end

  # textpassword changes hashpasword
  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
