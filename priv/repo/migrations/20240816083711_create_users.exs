defmodule BetBucket.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :phone_number, :string, null: false
      add :password_hash, :string, null: false
      add :balance, :decimal, precision: 10, scale: 2, default: 0.00
      add :is_verified, :boolean, default: false, null: false
      add :otp, :string
      add :otp_expires_at, :utc_datetime
      add :role_id, references(:roles, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:users, [:username]) #
    create unique_index(:users, [:phone_number])
  end
end
