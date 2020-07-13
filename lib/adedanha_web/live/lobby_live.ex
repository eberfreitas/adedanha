defmodule AdedanhaWeb.LobbyLive do
  use AdedanhaWeb, :live_view

  alias Adedanha.Lobby
  alias Adedanha.Room

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_event("create", _params, socket) do
    socket =
      case Lobby.create_room() do
        nil ->
          socket |> put_flash(:error, gettext("Houve um erro ao criar uma nova sala. Tente novamente!"))
        pid ->
          socket |> push_redirect(to: "/room/#{Room.get_id(pid)}")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("join", %{"room_id" => room_id}, socket) do
    room_id = String.trim(room_id)

    socket =
      case Lobby.get_room(room_id) do
        {:ok, pid} ->
          socket |> push_redirect(to: "/room/#{Room.get_id(pid)}")
        {:error, msg} ->
          socket |> put_flash(:error, msg)
      end

    {:noreply, socket}
  end
end
