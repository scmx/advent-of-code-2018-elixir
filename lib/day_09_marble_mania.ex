defmodule Adventofcode.Day09MarbleMania do
  use Adventofcode

  alias Adventofcode.Circle

  @enforce_keys [:last, :marbles, :players]
  defstruct turn: 0, last: 0, marbles: nil, players: {}

  def winning_score(input) do
    input
    |> new
    |> play
  end

  def winning_score_times_hundred(input) do
    input
    |> new
    |> Map.update(:last, nil, &(&1 * 100))
    |> play
  end

  defp new(input) do
    [player_count, last_marble] = parse(input)

    players = 1..player_count |> Enum.map(fn _ -> 0 end) |> List.to_tuple()
    marbles = Circle.new() |> Circle.insert_next(0)

    %__MODULE__{last: last_marble, marbles: marbles, players: players}
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
    marbles =
      state.marbles
      |> Circle.move_prev()
      |> Circle.move_prev()
      |> Circle.move_prev()
      |> Circle.move_prev()
      |> Circle.move_prev()
      |> Circle.move_prev()
      |> Circle.move_prev()

    %{state | marbles: marbles}
  end

  def move_forward_twice_and_insert_marble(state) do
    marbles = Circle.move_next(state.marbles)

    %{state | marbles: Circle.insert_next(marbles, state.turn)}
  end

  def remove_current_marble(state) do
    %{state | marbles: Circle.remove_current(state.marbles)}
  end

  def assign_score_to_player(state) do
    score = state.turn + Circle.current(state.marbles)
    players = update_elem(state.players, player_index(state), &(&1 + score))

    %{state | players: players}
  end

  def player_index(state) do
    rem(state.turn - 1, tuple_size(state.players))
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
