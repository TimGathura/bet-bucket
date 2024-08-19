defmodule BetBucket.RolePermissions.RolePermission do
  use Ecto.Schema

  schema "role_permissions" do
    belongs_to :role, BetBucket.Roles.Role
    belongs_to :permission, BetBucket.Permissions.Permission

    timestamps()
  end
end
