defmodule BetBucket.Repo do
  use Ecto.Repo,
    otp_app: :bet_bucket,
    adapter: Ecto.Adapters.Postgres
end
