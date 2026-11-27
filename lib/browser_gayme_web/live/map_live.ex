defmodule BrowserGaymeWeb.MapLive do
  use BrowserGaymeWeb, :live_view
  
  def mount(_params, _session, socket) do
    map_data = [
      %{id: 0, x: 1, y: 1, to: [1], p_loc: false},
      %{id: 1, x: 2, y: 1, to: [2, 3, 5], p_loc: false},
      %{id: 2, x: 3, y: 1, to: [3, 4], p_loc: false},
      %{id: 3, x: 3, y: 2, to: [8, 9], p_loc: true},
      %{id: 4, x: 4, y: 1, to: [], p_loc: false},
      %{id: 5, x: 2, y: 3, to: [6], p_loc: false},
      %{id: 6, x: 3, y: 3, to: [7], p_loc: false},
      %{id: 7, x: 3, y: 4, to: [], p_loc: false},
      %{id: 8, x: 4, y: 2, to: [], p_loc: false},
      %{id: 9, x: 4, y: 3, to: [], p_loc: false}
    ]

    {:ok, stream(socket, :map, map_data |> set_movable())}
  end

  def set_movable(map_data) do
    p_loc = Enum.find(map_data, fn room -> room.p_loc end)
    result = Enum.map(map_data, &Map.put(&1, :movable, p_loc.id in &1[:to]))
    Enum.reduce(p_loc.to, result, fn x, acc ->
      Enum.map(acc, fn room ->
        case room do
          %{id: ^x} -> %{room | movable: true}
          _ -> room
        end
      end)
    end)
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
        <div phx-update="stream" id="map" class="map hidden">
            <div
                :for={{dom_id, room} <- @map}
                class={get_room_class(room)}
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

             // Center player position
             const p_loc = document.querySelector(".room-p-loc")
             const style_start = "calc(50% - var(--room-size) - "
             const style_end = "px)"
             map.style.left = style_start + p_loc.offsetLeft + style_end
             map.style.top = style_start + p_loc.offsetTop + style_end

             // Unhide map
             map.classList.remove("hidden")
         }
     }
    </script>
    """
  end

  def get_room_class(room) do
    "room" <> get_p_loc_class(room) <> get_movable_class(room)
  end

  def get_p_loc_class(room) do
    if room.p_loc, do: " room-p-loc", else: ""
  end

  def get_movable_class(room) do
    if room.movable, do: " room-movable", else: ""
  end
end
