defmodule BetBucket.Bets.Bet do
  use Ecto.Schema

  schema "bets" do
    field :bet_type, :string
    field :amount, :decimal
    field :odds, :decimal
    field :status, Ecto.Enum, values: [:pending, :won, :lost]

    belongs_to :user, BetBucket.Users.User
    belongs_to :match, BetBucket.Matches.Match

    timestamps()
  end
end
