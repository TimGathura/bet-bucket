defmodule BetBucket.Users do
  alias BetBucket.Sports.Sport
  alias BetBucket.Users.User
  alias BetBucket.Matches.Match
  alias BetBucket.Repo

  import Ecto.Query

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_with_role(attrs) do
    create_user(attrs)
    |> Ecto.assoc(:role)
    |> Repo.update()
  end

  def list_all_games do
    Repo.all(Sport)
  end

  def list_current_matches(curr_time) do
    from m in Match, where: m.kick_off <= ^curr_time
  end
end
