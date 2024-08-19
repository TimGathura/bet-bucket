defmodule BetBucket.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt

  schema "users" do
    field :username, :string
    field :phone_number, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :balance, :decimal, default: Decimal.new("0.00")
    field :is_verified, :boolean, default: false
    field :otp, :string
    field :otp_expires_at, :utc_datetime

    belongs_to :role, BetBucket.Roles.Role

    timestamps()
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:username, :phone_number])
    |> validate_required([:username, :phone_number])
    |> validate_length(:username, min: 3, max: 20)
    |> validate_format(:phone_number, ~r|^\+?[1-9]\d{1,14}$|)
    |> unique_constraint(:username) ##
    |> unique_constraint(:phone_number)
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 20)
    |> put_password_hash()
  end

  def verify_changeset(user) do
    change(user, is_verified: true)
  end

  def otp_changeset(user, attrs) do
    user
    |> cast(attrs, [:otp, :otp_expires_at])
    |> validate_required([:otp, :otp_expires_at])
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
