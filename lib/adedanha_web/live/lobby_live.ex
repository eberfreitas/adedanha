defmodule AdedanhaWeb.LobbyLive do
  use AdedanhaWeb, :live_view

  alias Adedanha.Lobby
  alias Adedanha.Room

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_event("create", %{"nickname" => first_player}, socket) do
    first_player = String.trim(first_player)

    socket =
      if first_player == "" do
        socket |> put_flash(:error, gettext("Você precisa informar um apelido válido."))
      else
        room = Lobby.create_room({first_player, true})

        socket
        |> assign_new(:player, first_player)
        |> assign_new(:room, room)
        |> push_redirect(to: "/room")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("join", %{"nickname" => nickname, "room_id" => room_id}, socket) do
    nickname = String.trim(nickname)
    room_id = String.trim(room_id)

    socket =
      with {:ok, pid} <- Lobby.get_room(room_id),
           :ok <- Room.add_player(pid, nickname) do
        socket
        |> assign_new(:player, nickname)
        |> assign_new(:room, pid)
        |> push_redirect(to: "/room")
      else
        :error ->
          socket |> put_flash(:error, "A sala não aceita mais jogadores ou não existe.")

        {:error, reason} ->
          socket |> put_flash(:error, reason)
      end

    {:noreply, socket}
  end
end
