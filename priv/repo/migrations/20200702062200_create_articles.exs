defmodule NovelService.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles, primary_key: false) do
      add :hash_id, :string, primary_key: true
      add :title, :string, null: false
      add :content, :text
      add :views, :integer
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:articles, [:user_id])
  end
end
