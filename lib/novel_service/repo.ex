defmodule NovelService.Repo do
  use Ecto.Repo,
    otp_app: :novel_service,
    adapter: Ecto.Adapters.Postgres
end
