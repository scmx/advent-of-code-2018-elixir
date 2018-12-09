defmodule Adventofcode.Day09MarbleMania do
  use Adventofcode

  @enforce_keys [:last, :marbles, :players]
  defstruct turn: 0, last: 0, current: 1, marbles: {}, players: {}

  def winning_score(input) do
    input
    |> new
    |> play
  end

  defp new(input) do
    [player_count, last_marble] = parse(input)

    players = 1..player_count |> Enum.map(fn _ -> 0 end) |> List.to_tuple()

    %__MODULE__{last: last_marble, marbles: {0}, players: players}
  end

  defp play(%{turn: turn, last: turn} = state) do
    state.players
    |> Tuple.to_list()
    |> Enum.max()
  end

  defp play(state) do
    state
    |> update_turn
    |> update_marbles
    |> play
  end

  defp update_turn(state) do
    %{state | turn: posrem(state.turn + 1, state.last)}
  end

  defp update_marbles(%{turn: turn} = state) when rem(turn, 23) == 0 do
    state
    |> move_backward_seven_times
    |> assign_score_to_player
    |> remove_current_marble
  end

  defp update_marbles(state) do
    move_forward_twice_and_insert_marble(state)
  end

  def move_backward_seven_times(state) do
    size = tuple_size(state.marbles)
    current = rem(state.current - 7 - 1 + size, size) + 1

    %{state | current: current}
  end

  def move_forward_twice_and_insert_marble(state) do
    current = rem(state.current, tuple_size(state.marbles)) + 2
    marbles = Tuple.insert_at(state.marbles, current - 1, state.turn)

    %{state | current: current, marbles: marbles}
  end

  def remove_current_marble(state) do
    %{state | marbles: Tuple.delete_at(state.marbles, state.current)}
  end

  def assign_score_to_player(state) do
    score = state.turn + current_marble(state)
    players = update_elem(state.players, player_index(state), &(&1 + score))

    %{state | players: players}
  end

  def player_index(state) do
    rem(state.turn - 1, tuple_size(state.players))
  end

  def current_marble(state) do
    elem(state.marbles, state.current - 1)
  end

  defp parse(input) do
    ~r/\d+/
    |> Regex.scan(input)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end

  # 1-indexed modulo contraint
  defp posrem(dividend, divisor) do
    case rem(dividend - 1, divisor) + 1 do
      num when num < 0 -> divisor - num
      num -> num
    end
  end

  def update_elem(tuple, index, fun) do
    value = elem(tuple, index)

    put_elem(tuple, index, fun.(value))
  end
end
