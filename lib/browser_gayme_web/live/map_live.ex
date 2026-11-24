defmodule BrowserGaymeWeb.MapLive do
  use BrowserGaymeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <h1>TODO List</h1>
      <ol>
	<li>Design navigation UI</li>
      </ol>
    </Layouts.app>
    """
  end
end
