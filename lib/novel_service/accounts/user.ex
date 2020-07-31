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
    has_many :articles, Article


    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password], message: "空白になっています")
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: "メールアドレスの形式が間違っています")
    |> validate_format(:password, ~r/^(?=.*?[a-z])(?=.*?\d)[a-z\d]{8,100}$/i, message: "半角英数字それぞれ1文字以上含む8文字以上100文字以下の文字にして下さい")
    |> validate_confirmation(:password, message: "パスワードと一致しません")
    |> IO.inspect
    |> put_pass_hash()
  end

  #textpassword changes hashpasword
  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
