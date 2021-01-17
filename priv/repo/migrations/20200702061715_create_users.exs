defmodule NovelService.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: false
      add :bio, :text
      add :user_link, :text
      add :have_articles, :integer

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
