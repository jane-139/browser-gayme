defmodule BrowserGaymeWeb.MapLive do
  use BrowserGaymeWeb, :live_view

  def mount(_params, _session, socket) do
    map_data = [
      %{id: 0, x: 1, y: 1, to: [1]},
      %{id: 1, x: 2, y: 1, to: [2, 3, 5]},
      %{id: 2, x: 3, y: 1, to: [3, 4]},
      %{id: 3, x: 3, y: 2, to: []},
      %{id: 4, x: 4, y: 1, to: []},
      %{id: 5, x: 2, y: 3, to: [6]},
      %{id: 6, x: 3, y: 3, to: [7]},
      %{id: 7, x: 3, y: 4, to: []}
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
                <div :for={to <- room.to} data-to={to} class="to-id"></div>
            </div>
            <svg id="room-connections"></svg>
        </div>
    </div>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".Map">
     export default {
         mounted() {
             // Handle click and dragging
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

             // Draw room connections
             function get_center(element) {
                 return [
                     element.offsetLeft + element.offsetWidth / 2,
                     element.offsetTop + element.offsetHeight / 2
                 ]
             }
             
             for (const to_id of document.querySelectorAll(".to-id")) {
                 const parent = to_id.parentElement
                 const target = document.getElementById("map-" + to_id.dataset.to)
                 const parent_center = get_center(parent)
                 const target_center = get_center(target)

                 const line = document.createElementNS(
                     'http://www.w3.org/2000/svg',
                     'line'
                 )
                 line.setAttribute('x1', parent_center[0])
                 line.setAttribute('y1', parent_center[1])
                 line.setAttribute('x2', target_center[0])
                 line.setAttribute('y2', target_center[1])
                 document.getElementById('room-connections').appendChild(line)
             }
         }
     }
    </script>
    """
  end
end
