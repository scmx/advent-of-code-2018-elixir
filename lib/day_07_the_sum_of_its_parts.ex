defmodule Adventofcode.Day07TheSumOfItsParts do
  use Adventofcode

  defstruct [:steps, :reqs, :completed]

  def steps_in_order(input) do
    input
    |> String.trim_trailing("\n")
    |> String.split("\n")
    |> Enum.map(&parse_step/1)
    |> new
    |> iterate
    |> Map.get(:completed)
    |> Enum.join("")
  end

  def new(reqs) do
    %__MODULE__{steps: steps_list(reqs), reqs: reqs, completed: []}
  end

  def iterate(state) do
    case determine_order(state) do
      ^state -> state
      new_state -> iterate(new_state)
    end
  end

  def determine_order(state) do
    ready = ready_list(state) |> Enum.take(1)
    steps = state.steps -- ready
    reqs = Enum.reject(state.reqs, fn [a, _] -> Enum.member?(ready, a) end)
    completed = state.completed ++ ready

    %{state | steps: steps, reqs: reqs, completed: completed}
  end

  defp steps_list(reqs) do
    reqs
    |> Enum.flat_map(& &1)
    |> Enum.sort()
    |> Enum.uniq()
  end

  def ready_list(%{steps: steps, reqs: reqs}) do
    steps
    |> Enum.filter(&do_ready(&1, reqs))
    |> Enum.sort()
  end

  defp do_ready(step, reqs) do
    Enum.all?(reqs, fn
      [_, ^step] -> false
      _ -> true
    end)
  end

  def parse_step(line) do
    case Regex.scan(~r/^.+ (\w) .+ (\w) .+$/, line) do
      [[_, a, b]] -> [a, b]
    end
  end
end
