defmodule BetBucket.Sports.Sport do
  use Ecto.Schema

  schema "sports" do
    field :name, :string

    timestamps()
  end
end
