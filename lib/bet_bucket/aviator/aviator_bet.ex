defmodule BetBucket.Aviators.AviatorBet do
  use Ecto.Schema

  schema "aviator_bets" do
    field :amount, :decimal
    field :outcome, Ecto.Enum, values: [:win, :loss]

    belongs_to :user, BetBucket.Users.User

    timestamps()
  end
end
