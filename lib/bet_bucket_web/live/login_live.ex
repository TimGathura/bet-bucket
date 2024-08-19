defmodule BetBucketWeb.LoginLive do
  use BetBucketWeb, :blank_layout
  alias BetBucket.Accounts
  alias BetBucketWeb.UserAuth

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns)
    {:ok, assign(socket, form: to_form(%{}))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-md mx-auto mt-10">
      <h1 class="text-3xl font-bold mb-5">Log In</h1>
      <.form :let={f} for={@form} phx-submit="login" class="space-y-4">
        <.input field={f[:phone_number]} type="tel" label="Phone Number" required />
        <.input field={f[:password]} type="password" label="Password" required />
        <.button type="submit" class="w-full">Log In</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def handle_event("login", %{"phone_number" => phone_number, "password" => password}, socket) do
    case Accounts.authenticate_user(phone_number, password) do
      {:ok, user} ->
        {:noreply,
         socket
         |> UserAuth.log_in_user(user, %{"remember_me" => "true"})
         |> assign(:current_user, user)
         |> put_flash(:info, "Logged in successfully.")
         |> push_navigate(to: ~p"/")}

      {:error, _reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Invalid phone number or password")
         |> assign(form: to_form(%{}))}
    end
  end
end
