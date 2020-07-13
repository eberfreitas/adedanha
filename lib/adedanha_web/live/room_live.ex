defmodule AdedanhaWeb.RoomLive do
  use AdedanhaWeb, :live_view

  alias Adedanha.Lobby
  alias Adedanha.Room

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    socket =
      case Lobby.get_room(id) do
        {:error, msg} -> socket |> assign(:room_pid, nil) |> put_flash(:error, msg)
        # {:ok, pid} -> socket |> assign(:room_pid, pid) |> assign(:room, Room.get_state(pid)) |> assing
        {:ok, pid} ->
          socket
          |> assign(room_pid: pid, room: Room.get_state(pid), player: nil)
      end

    {:ok, socket}
  end
end
