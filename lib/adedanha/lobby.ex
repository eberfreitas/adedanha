defmodule Adedanha.Lobby do
  use GenServer

  alias Adedanha.Room

  def start_link(_opts), do: GenServer.start_link(__MODULE__, [], name: Lobby)

  def create_room(first_player), do: GenServer.call(Lobby, {:create_room, first_player})

  def get_room(id) do
    case Map.get(rooms(), id) do
      nil -> :error
      pid -> {:ok, pid}
    end
  end

  def rooms(), do: GenServer.call(Lobby, :rooms)

  def init(_init_arg), do: {:ok, %{}}

  def handle_call({:create_room, first_player}, _from, state) do
    room_pid =
      case Room.start_link() do
        {:ok, pid} -> pid
        _ -> nil
      end

    state =
      case room_pid do
        nil -> state
        pid ->
          Room.add_player(pid, first_player)
          state |> Map.put(Room.get_id(pid), room_pid)
      end

    {:reply, room_pid, state}
  end

  def handle_call(:rooms, _from, state), do: {:reply, state, state}
end
