defmodule Adedanha.Room do
  use GenServer

  import AdedanhaWeb.Gettext

  alias Phoenix.PubSub

  @state %{
    id: "",
    players: [],
    max_players: 10,
    themes: [
      "Nome",
      "CEP",
      "Filme/Série",
      "MSÉ",
      "Fruta",
      "Marca",
      "Inseto",
      "Cor",
      "Animal",
      "Personagem"
    ],
    round_timeout: 120,
    state: :waiting_players
  }

  def start_link(opts \\ []), do: GenServer.start_link(__MODULE__, [], opts)

  def get_id(pid), do: GenServer.call(pid, :get_id)

  def get_state(pid), do: GenServer.call(pid, :get_state)

  def can_add_player?(pid) do
    state = get_state(pid)

    state.state == :waiting_players && Enum.count(state.players) < state.max_players
  end

  def add_player(pid, nickname, owner \\ false), do: GenServer.call(pid, {:add_player, nickname})

  def init(_init_arg) do
    state = @state |> Map.put(:id, HumanIDs.generate())

    {:ok, state}
  end

  def handle_call(:get_id, _from, state), do: {:reply, Map.get(state, :id), state}

  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  def handle_call({:add_player, nickname}, _from, state) do
    players_nicknames = state.players |> Enum.map(fn {n, _} -> n end)
    player = {nickname, Enum.empty?(state.players)}

    {players, result} =
      cond do
        Enum.member?(players_nicknames, nickname) ->
          {state.players, {:error, gettext("Este apelido já está sendo usado.")}}

        state.state != :waiting_players ->
          {state.players, {:error, gettext("A sala não aceita mais jogadores.")}}

        true ->
          PubSub.broadcast(Adedanha.PubSub, "room:#{state.id}", :player_joined)

          {state.players ++ [player], {:ok, player}}
      end

    {:reply, result, state |> Map.put(:players, players)}
  end
end
