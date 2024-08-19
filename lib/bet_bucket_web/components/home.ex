defmodule BetBucketWeb.Components.Home do
  use BetBucketWeb, :html

  embed_templates "home_content.html"

  def home(assigns) do
    ~H"""
    <.home_content />
    """
  end
end
