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

  def build_grid(coordinates) do
    coordinates
    |> Enum.zip(names())
    |> Enum.into(%{})
  end

  def names do
    ?A..?Z
    |> Enum.map(&to_string([&1]))
    |> Enum.flat_map(fn a -> Enum.map(0..1, &"#{&1}#{a}") end)
    |> Enum.sort()
  end

  def grid_locations(range \\ 0..400) do
    Enum.flat_map(range, fn n -> Enum.map(range, &{n, &1}) end)
  end

  def closest_coordinates(grid, locations \\ grid_locations()) do
    locations
    |> Enum.map(&{&1, closest_coordinate(&1, grid)})
    |> Enum.into(%{})
  end

  def closest_coordinate(coordinate, grid) do
    case do_closest(coordinate, grid) |> Enum.sort() do
      [{distance, _}, {distance, _} | _] -> ".."
      [{_, other_coordinate_name} | _] -> String.downcase(other_coordinate_name)
    end
  end

  defp do_closest(coordinate, grid) do
    Enum.map(grid, fn {other_coordinate, other_coordinate_name} ->
      {manhattan_distance(coordinate, other_coordinate), other_coordinate_name}
    end)
  end
end
