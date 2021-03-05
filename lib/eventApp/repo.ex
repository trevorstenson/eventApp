defmodule EventApp.Repo do
  use Ecto.Repo,
    otp_app: :eventApp,
    adapter: Ecto.Adapters.Postgres
end
