defmodule Adventofcode.Day06ChronalCoordinates do
  use Adventofcode

  def manhattan_distance({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  def parse_coordinates(input) do
    input
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.map(&parse_coordinate/1)
  end

  defp parse_coordinate(coordinate) do
    coordinate
    |> String.split(", ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
