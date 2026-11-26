defmodule BrowserGaymeWeb.MapLive do
  use BrowserGaymeWeb, :live_view

  def mount(_params, _session, socket) do
    map_data = [
      %{id: 0, x: 1, y: 1},
      %{id: 1, x: 2, y: 1},
      %{id: 2, x: 3, y: 1},
      %{id: 3, x: 3, y: 2},
      %{id: 4, x: 4, y: 1},
      %{id: 5, x: 2, y: 3},
      %{id: 6, x: 3, y: 3},
      %{id: 7, x: 3, y: 4}
    ]

    {:ok, stream(socket, :map, map_data)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="frame">
        <div phx-update="stream" id="map" class="map">
          <div
            :for={{dom_id, room} <- @streams.map}
            class="room"
            id={dom_id}
            style={"grid-row: #{room.y}; grid-column: #{room.x}"}
          >
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
