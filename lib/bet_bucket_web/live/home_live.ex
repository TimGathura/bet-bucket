defmodule BetBucketWeb.HomeLive do
  use BetBucketWeb, :blank_layout

  import BetBucketWeb.Components.Nav
  import BetBucketWeb.Components.Aviator
  alias BetBucketWeb.UserAuth

  def mount(_params, session, socket) do
    socket =
      socket
      |> assign(:session, session)
      |> UserAuth.fetch_current_user()

    {:ok, socket}
  end


  def render(assigns) do
    ~H"""
    <div class="h-screen">
      <.nav_content current_user={@current_user}/>
      <.aviator_content }/>
    </div>
    """
  end
end
