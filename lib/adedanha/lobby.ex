defmodule Adedanha.Lobby do
  use GenServer

  import AdedanhaWeb.Gettext

  alias Adedanha.Room

  def start_link(_opts), do: GenServer.start_link(__MODULE__, [], name: Lobby)

  def create_room(), do: GenServer.call(Lobby, :create_room)

  def get_room(id) do
    case Map.get(rooms(), id) do
      nil -> {:error, gettext("A sala não existe ou o jogo já terminou! :(")}
      pid -> {:ok, pid}
    end
  end

  def rooms(), do: GenServer.call(Lobby, :rooms)

  def init(_init_arg), do: {:ok, %{}}

  def handle_call(:create_room, _from, state) do
    room_pid =
      case Room.start_link() do
        {:ok, pid} -> pid
        _ -> nil
      end

    state =
      case room_pid do
        nil -> state
        pid -> state |> Map.put(Room.get_id(pid), room_pid)
      end

    {:reply, room_pid, state}
  end

  def handle_call(:rooms, _from, state), do: {:reply, state, state}
end
