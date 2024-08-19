defmodule BetBucket.Permissions.Permission do
  use Ecto.Schema

  import Ecto.Changeset

  schema "permissions" do
    field :name, :string

    many_to_many :roles, BetBucket.Roles.Role, join_through: BetBucket.RolePermissions.RolePermission

    timestamps()
  end

  def changeset(permissions, attrs) do
    permissions
    |> cast(attrs, [:name])
  end
end
