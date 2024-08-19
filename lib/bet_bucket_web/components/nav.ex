defmodule BetBucketWeb.Components.Nav do
  use BetBucketWeb, :html

  embed_templates "nav_content.html"

  def nav(assigns) do
    IO.inspect(assigns, label: "Nav component assigns")
    ~H"""
    <.nav_content current_user={@current_user} />
    """
  end
end
