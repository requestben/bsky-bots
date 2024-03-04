defmodule BskyBots.Repo do
  use Ecto.Repo,
    otp_app: :bsky_bots,
    adapter: Ecto.Adapters.Postgres
end
