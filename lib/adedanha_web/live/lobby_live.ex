defmodule AdedanhaWeb.LobbyLive do
  use AdedanhaWeb, :live_view

  alias Adedanha.Lobby

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_event("create", %{"nickname" => first_player}, socket) do
    first_player = String.trim(first_player)

    socket =
      if first_player == "" do
        socket |> put_flash(:error, gettext("Você precisa informar um apelido válido."))
      else
        room = Lobby.create_room(first_player)

        socket
        |> assigns(player: first_player, room: room)
        |> push_redirect(to: "/room")
      end

    {:noreply, socket}
  end
end
