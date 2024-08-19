defmodule BetBucket.Users.Unverified do
  use Ecto.Schema

  schema "unverifieds" do
    field :username, :string
    field :phone_number, :string
    field :password_hash, :string
  end
end
