defmodule BetBucket.Odds.Odd do
  use Ecto.Schema

  schema "odds" do
    field :bet_type, Ecto.Enum, values: [:win, :draw]
    field :odds_value, :decimal

    belongs_to :match, BetBucket.Matches.Match

    timestamps()
  end
end
