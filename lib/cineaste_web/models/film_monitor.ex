defmodule CineasteWeb.FilmMonitor do
  use GenServer

  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def set_state(state) do
    GenServer.call(__MODULE__, {:set_state, state})
  end

  def get_state() do
    GenServer.call(__MODULE__, {:get_state})
  end

  def init(args) do
    {:ok, args}
  end

  def handle_call({:set_state, new_state}, _from, _state) do
    {:reply, new_state, new_state}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end
end