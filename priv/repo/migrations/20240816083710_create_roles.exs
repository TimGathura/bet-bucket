defmodule BetBucket.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string, null: false

      timestamps()
    end

    create index(:roles, [:name])
  end
end
