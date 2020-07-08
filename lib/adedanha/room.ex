defmodule Adedanha.Room do
  use GenServer

  @state %{
    id: "",
    players: [],
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

  def add_player(pid, nickname), do: GenServer.call(pid, {:add_player, nickname})

  def init(_init_arg) do
    state = @state |> Map.put(:id, HumanIDs.generate())

    {:ok, state}
  end

  def handle_call(:get_id, _from, state), do: {:reply, Map.get(state, :id), state}

  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  def handle_call({:add_player, nickname}, _from, state) do
    nickname = String.trim(nickname)

    {players, result} =
      state.players
      |> Enum.member?(nickname)
      |> if do
        {state.players, {:error, "Nickname not available"}}
      else
        {state.players ++ [nickname], :ok}
      end

    {:reply, result, state |> Map.put(:players, players)}
  end
end
