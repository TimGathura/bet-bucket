defmodule BetBucketWeb.VerificationLive do
  use BetBucketWeb, :blank_layout
  alias BetBucket.Accounts

  @impl true
  def mount(%{"id" => user_id}, _session, socket) do
    {:ok, assign(socket, user_id: user_id, otp: "")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-md mx-auto mt-10">
      <h1 class="text-3xl font-bold mb-5">Verify Your Account</h1>
      <.form :let={f} for={%{}} phx-submit="verify" class="space-y-4">
        <.input field={f[:otp]} type="text" label="Enter OTP" required />
        <.button type="submit" class="w-full">Verify</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def handle_event("verify", %{"otp" => otp}, socket) do
    case Accounts.verify_user(socket.assigns.user_id, otp) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Account verified successfully.")
         |> push_navigate(to: ~p"/")}

      {:error, _reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Invalid OTP. Please try again.")
         |> assign(otp: "")}
    end
  end
end
