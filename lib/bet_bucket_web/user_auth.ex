defmodule BetBucketWeb.UserAuth do
  use BetBucketWeb, :live_view
  alias BetBucket.Accounts

  @remember_me_cookie "_bet_bucket_web_user_remember_me"
  @remember_me_options [sign: true, max_age: 60 * 60 * 24 * 60, same_site: "Lax"]

  def log_in_user(socket, user, params \\ %{}) do
    token = Accounts.generate_user_session_token(user)
    encoded_token = Base.encode64(token)

    socket
    |> assign(:user_token, encoded_token)
    |> assign(:current_user, user)
    |> put_flash(:info, "Logged in successfully.")
    |> maybe_write_remember_me_cookie(encoded_token, params)
  end

  defp maybe_write_remember_me_cookie(socket, token, %{"remember_me" => "true"}) do
    push_event(socket, "set_cookie", %{
      key: @remember_me_cookie,
      value: token,
      max_age: @remember_me_options[:max_age],
      same_site: @remember_me_options[:same_site]
    })
  end

  defp maybe_write_remember_me_cookie(socket, _token, _params), do: socket

  def fetch_current_user(socket) do
    case get_session_token_from_socket(socket) do
      nil -> assign(socket, :current_user, nil)
      encoded_token ->
        token = Base.decode64!(encoded_token)
        user = Accounts.get_user_by_session_token(token)
        assign(socket, :current_user, user)
    end
  end

  defp get_session_token_from_socket(%{assigns: %{user_token: token}}) when is_binary(token), do: token
  defp get_session_token_from_socket(_socket), do: nil
end
