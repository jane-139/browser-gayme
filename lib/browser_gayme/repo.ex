defmodule BrowserGayme.Repo do
  use Ecto.Repo,
    otp_app: :browser_gayme,
    adapter: Ecto.Adapters.Postgres
end
