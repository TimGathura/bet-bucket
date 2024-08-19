defmodule BetBucketWeb.Components.Aviator do
  use BetBucketWeb, :html

  embed_templates "aviator_content.html"

  def aviator(assigns) do
    ~H"""
    <.aviator_content />
    """
  end
end
