defmodule BetBucket.Accounts do
  alias BetBucket.Users.User, warn: false
  alias BetBucket.Users.UserToken, warn: false
  alias BetBucket.Repo, warn: false

  import Ecto.Query, warn: false

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        otp = generate_otp()
        otp_expires_at = DateTime.utc_now() |> DateTime.add(10 * 60, :second) # OTP expires in 10 minutes
        case store_otp(user, otp, otp_expires_at) do
          {:ok, updated_user} ->
            send_otp_sms(user.phone_number, otp)
            {:ok, updated_user}
          {:error, changeset} ->
            Repo.delete(user) # Rollback user creation if OTP storage fails
            {:error, changeset}
        end
      error ->
        error
    end
  end

  def change_user(%User{} = user, attrs\\ %{}) do
    User.changeset(user, attrs)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def verify_user(user_id, otp) do
    user = get_user!(user_id)
    if verify_otp(user, otp) do
      user
      |> User.verify_changeset()
      |> Repo.update()
    else
      {:error, "Invalid OTP"}
    end
  end

  defp generate_otp do
    :crypto.strong_rand_bytes(3)
    |> Base.encode16()
    |> binary_part(0, 6)
  end

  defp store_otp(user, otp, otp_expires_at) do
    user
    |> User.otp_changeset(%{otp: otp, otp_expires_at: otp_expires_at})
    |> Repo.update()
  end

  defp verify_otp(user, otp) do
    # In a real application, you'd want to implement proper OTP verification
    # For now, we'll just compare the stored OTP with the provided one
    # and ensure the OTP hasn't expired
    user.otp == otp && DateTime.compare(user.otp_expires_at, DateTime.utc_now()) == :gt
  end

  def send_otp_sms(phone_number, otp) do
    # In a real application, you'd integrate with an SMS service here
    # For now, we'll just log the OTP
    IO.puts("Sending OTP #{otp} to #{phone_number}")
  end



  def authenticate_user(phone_number, password) do
    User
    |> Repo.get_by(phone_number: phone_number)
    |> case do
      nil ->
        Bcrypt.no_user_verify()
        {:error, :invalid_credentials}
      user ->
        if Bcrypt.verify_pass(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  # Session management contexts
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  def delete_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

end
