defmodule BetBucket.Roles.Role do
  use Ecto.Schema
  import Ecto.Changeset, warn: false

  schema "roles" do
    field :name, Ecto.Enum, values: [:admin, :user, :moderator]

    has_many :users, BetBucket.Users.User

    many_to_many :permissions, BetBucket.Permissions.Permission, join_through: BetBucket.RolePermissions.RolePermission

    timestamps()
  end

  def changeset(roles, attrs) do
    roles
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
