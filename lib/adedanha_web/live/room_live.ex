defmodule AdedanhaWeb.RoomLive do
  use AdedanhaWeb, :live_view

  alias Adedanha.Lobby
  alias Adedanha.Room
  alias Phoenix.PubSub

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    socket =
      case Lobby.get_room(id) do
        {:error, msg} ->
          socket |> assign(:id, nil) |> put_flash(:error, msg)

        {:ok, pid} ->
          PubSub.subscribe(Adedanha.PubSub, "room:#{id}")

          socket |> assign(id: id, pid: pid, state: Room.get_state(pid), player: nil)
      end

    {:ok, socket}
  end

  def handle_event("join", %{"nickname" => nickname}, socket) do
    nickname = String.trim(nickname)
    pid = socket.assigns.pid

    socket =
      cond do
        nickname == "" ->
          socket |> put_flash(:error, gettext("Preencha um apelido."))

        Room.can_add_player?(pid) == false ->
          socket |> put_flash(:error, gettext("A sala está lotada ou o jogo já começou :("))

        true ->
          {:ok, player} = Room.add_player(pid, nickname)

          socket |> assign(player: player)
      end

    {:noreply, socket}
  end

  def handle_info(:player_joined, socket) do
    {:noreply, socket |> assign(state: Room.get_state(socket.assigns.pid))}
  end
end
