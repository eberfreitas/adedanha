defmodule AdedanhaWeb.RoomLive.WaitingPlayers do

  use AdedanhaWeb, :live_component

  def render(assigns) do
    ~L"""
    <h1><%= gettext("Sala de jogo") %></h1>

    <section>
      <h2>Jogadores</h2>

      <%= if Enum.count(@room.players) > 0 do %>
        <ul>
          <%= for player <- @room.players do %>
            <li><%= player |> elem(0) %></li>
          <% end %>
        </ul>
      <% else %>
        <%= gettext("Esta sala está vazia.") %>
      <% end %>
    </section>

    <%= if @player == nil do %>
      <div>
        <h2>Entrar na sala</h2>

        <form phx-submit="join">
          <label>
            <%= gettext("Seu apelido") %>
            <input type="text" name="nickname">
          </label>

          <button><%= gettext("Entrar") %></button>
        </form>
      </div>
    <% end %>
    """
  end
end
