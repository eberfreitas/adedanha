defmodule AdedanhaWeb.RoomLive.WaitingPlayers do

  use AdedanhaWeb, :live_component

  def render(assigns) do
    ~L"""
    <h1><%= gettext("Sala de jogo") %></h1>

    <section>
      <h2>Jogadores</h2>

      <%= if Enum.count(@state.players) > 0 do %>
        <ul>
          <%= for player <- @state.players do %>
            <li><%= player |> elem(0) %></li>
          <% end %>
        </ul>
      <% else %>
        <%= gettext("Esta sala está vazia.") %>
      <% end %>
    </section>

    <%= if @player == nil do %>
      <%= if Enum.count(@state.players) == @state.max_players do %>
        <p><strong><%= gettext("A sala já está lotada.") %></strong></p>
      <% else %>
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
    <% else %>
      <%= if elem(@player, 1) == true do %>
        <button phx-click="start_game"><%= gettext("Começar jogo") %></button>
      <% else %>
        <p><%= gettext("Aguarde o jogo começar...") %></p>
      <% end %>
    <% end %>
    """
  end
end
