defmodule AdedanhaWeb.RoomLive do
  use AdedanhaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect(socket)
    {:ok, socket}
  end

  @impl true
  def handle_event("create", _params, socket) do
    {:noreply, true}
  end
end
