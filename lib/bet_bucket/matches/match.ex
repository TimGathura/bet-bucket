defmodule BetBucket.Matches.Match do
  use Ecto.Schema

  schema "matches" do
    field :status, Ecto.Enum, values: [:scheduled, :ongoing, :finished]
    field :home_score, :integer
    field :away_score, :integer
    
    belongs_to :sport, BetBucket.Sports.Sport
    belongs_to :home_team, BetBucket.Teams.Team
    belongs_to :away_team, BetBucket.Teams.Team

    # Start time
    timestamps()
  end
end
