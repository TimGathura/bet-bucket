defmodule BetBucketWeb.RegistrationLive do
  use BetBucketWeb, :blank_layout

  alias BetBucket.Accounts
  alias BetBucket.Users.User

  import BetBucketWeb.Components.Home
  import BetBucketWeb.Components.Nav, warn: false



  @impl true
  def mount(_params, _session, socket) do
    changeset =
      Accounts.change_user(%User{})
      |> IO.inspect(label: "User changeset in mount/3")
    {:ok, assign(socket, changeset: changeset)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-md mx-auto mt-10">
      <h1 class="text-3xl font-bold mb-5">Register</h1>
      <.form :let={f} for={@changeset} phx-submit="register" class="space-y-4">
        <.input field={f[:username]} type="text" label="Username" required />
        <.input field={f[:phone_number]} type="tel" label="Phone Number" required />
        <.input field={f[:password]} type="password" label="Password" required />
        <.button type="submit" class="w-full">Register</.button>
      </.form>
      <.home_content />
    </div>
    """
  end

  @impl true
  def handle_event("register", %{"user" => user_params}, socket) do
    user_params = IO.inspect(user_params, label: "User params in handle_event")

    case Accounts.register_user(user_params) do
      {:ok, user} ->
        user = IO.inspect(user, label: "Created User in handle_event")
        {:noreply,
         socket
         |> put_flash(:info, "User created successfully. Please verify your phone number.")
         |> push_navigate(to: ~p"/verify/#{user.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset = IO.inspect(changeset, label: "Error Changeset in handle_event")
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
