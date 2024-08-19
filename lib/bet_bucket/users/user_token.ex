defmodule BetBucket.Users.UserToken do
  use Ecto.Schema
  import Ecto.Query

  @rand_size 32

  schema "user_tokens" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string
    belongs_to :user, BetBucket.Users.User

    timestamps(updated_at: false)
  end

  def build_session_token(user) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %BetBucket.Users.UserToken{token: token, context: "session", user_id: user.id}}
  end

  def verify_session_token_query(token) do
    query =
      from token in token_and_context_query(token, "session"),
        join: user in assoc(token, :user),
        where: token.inserted_at > ago(60, "day"),
        select: user

    {:ok, query}
  end

  def token_and_context_query(token, context) do
    from BetBucket.Users.UserToken, where: [token: ^token, context: ^context]
  end
end
