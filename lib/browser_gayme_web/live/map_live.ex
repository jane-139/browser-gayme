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
      <.map map={@streams.map} />
    </Layouts.app>
    """
  end

  def map(assigns) do
    ~H"""
    <div class="frame" id="map-container" phx-hook=".Map">
      <div phx-update="stream" id="map" class="map">
        <div
          :for={{dom_id, room} <- @map}
          class="room"
          id={dom_id}
          style={"grid-row: #{room.y}; grid-column: #{room.x}"}
        >
        </div>
      </div>
    </div>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".Map">
     export default {
         mounted() {
             const map = document.getElementById("map")
             var mouseDown = false
             var offset = [0, 0]

             this.el.addEventListener('mousedown', function(e) {
                 mouseDown = true
                 offset = [
                     map.offsetLeft - e.clientX,
                     map.offsetTop - e.clientY
                 ]
             })

             document.addEventListener('mouseup', function() {
                 mouseDown = false
             })

             document.addEventListener('mousemove', function(e) {
                 e.preventDefault()
                 if (mouseDown) {
                     map.style.left = (e.clientX + offset[0]) + 'px'
                     map.style.top = (e.clientY + offset[1]) + 'px'
                 }
             })
         }
     }
    </script>
    """
  end
end
