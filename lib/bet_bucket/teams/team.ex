defmodule BetBucket.Teams.Team do
  use Ecto.Schema

  schema "teams" do
    field :name, :string

    belongs_to :sport, BetBucket.Sports.Sport
  end
end
