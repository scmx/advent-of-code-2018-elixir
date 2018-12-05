defmodule Adventofcode.Day05AlchemicalReaction do
  use Adventofcode

  def remaining_units(input) do
    input
    |> apply_reductions
    |> String.length()
  end

  def apply_reductions(input) do
    input
    |> String.to_charlist()
    |> reduce_repeatedly
    |> to_string
  end

  defp reduce_repeatedly(list) do
    case Enum.reverse(reduce(list)) do
      ^list -> list
      different -> different |> reduce_repeatedly
    end
  end

  defp reduce(characters, res \\ [])

  defp reduce([], res), do: res

  defp reduce([a], res), do: [a | res]

  defp reduce([a, b | tail], res)
       when abs(a - b) == 32,
       do: reduce(tail, res)

  defp reduce([a, b, c | tail], res)
       when abs(b - c) == 32,
       do: reduce([a | tail], res)

  defp reduce([a | tail], res), do: reduce(tail, [a | res])
end
