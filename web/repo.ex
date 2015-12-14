defmodule Exbugs.Repo do
  use Ecto.Repo, otp_app: :exbugs
  use Scrivener, page_size: 40
end
