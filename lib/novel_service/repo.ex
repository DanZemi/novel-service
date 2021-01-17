defmodule NovelService.Repo do
  use Ecto.Repo,
    otp_app: :novel_service,
    adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10
end
