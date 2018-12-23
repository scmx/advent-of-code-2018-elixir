defmodule Adventofcode.Day23ExperimentalEmergencyTeleportation do
  use Adventofcode

  defmodule Part1 do
    alias Adventofcode.Day23ExperimentalEmergencyTeleportation.Nanobots

    def solve(input) do
      input
      |> Nanobots.parse()
      |> nanobots_within_range_of_strongest_one()
      |> Enum.count()
    end

    defp nanobots_within_range_of_strongest_one(nanobots) do
      nanobots
      |> strongest_nanobot
      |> Nanobots.nanobots_within_range_of(nanobots)
    end

    defp strongest_nanobot(nanobots) do
      Enum.max_by(nanobots, fn {_x, _y, _z, radius} -> radius end)
    end
  end

  defmodule Part2 do
    alias Adventofcode.Day23ExperimentalEmergencyTeleportation.Nanobots

    def solve(input) do
      input
      |> coordinate_in_range_of_most_nanobots()
      |> distance_to_zero_for_closest_nanobot()
    end

    def coordinate_in_range_of_most_nanobots(input) do
      input
      |> Nanobots.parse()
      |> nanobots_within_range_of_coordinates()
      |> sort_coordinates_by_range()
      |> hd()
    end

    defp distance_to_zero_for_closest_nanobot({_coordinate, nanobots}) do
      nanobots
      |> Enum.map(&distance_to_zero/1)
      |> Enum.min()
    end

    defp sort_coordinates_by_range(coordinates) do
      Enum.sort_by(coordinates, &build_range/1, &sort_by_range/2)
    end

    defp build_range({coordinate, nanobots}) do
      {length(nanobots), distance_to_zero(coordinate)}
    end

    defp sort_by_range({length1, distance1}, {length2, distance2}) do
      length1 > length2 && distance1 <= distance2
    end

    def distance_to_zero(coordinate) do
      Nanobots.manhattan_distance(coordinate, {0, 0, 0, nil})
    end

    defp nanobots_within_range_of_coordinates(nanobots) do
      nanobots
      |> determine_axis_ranges()
      |> build_coordinates()
      |> do_determine_nanobots_within_range(nanobots)
    end

    defp do_determine_nanobots_within_range(coordinates, nanobots) do
      coordinates
      |> Enum.map(&{&1, determine_nanobots_within_range(&1, nanobots)})
      |> Enum.sort_by(fn {_coordinate, nanobots} -> length(nanobots) end)
    end

    defp determine_nanobots_within_range(coordinate, nanobots) do
      Enum.filter(nanobots, &Nanobots.within_range_of?(&1, coordinate))
    end

    defp determine_axis_ranges(nanobots) do
      nanobots
      |> Enum.map(fn {x, y, z, _radius} -> [x, y, z] end)
      |> transpose()
      |> Enum.map(&build_min_max_range/1)
      |> List.to_tuple()
    end

    defp build_coordinates({x_range, y_range, z_range}) do
      for x <- x_range, y <- y_range, z <- z_range, do: {x, y, z, nil}
    end

    defp transpose(list_of_lists) do
      list_of_lists
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)
    end

    defp build_min_max_range(values) do
      Enum.min(values)..Enum.max(values)
    end
  end

  defmodule Nanobots do
    def nanobots_within_range_of(nanobot, nanobots) do
      Enum.filter(nanobots, &within_range_of?(nanobot, &1))
    end

    def within_range_of?({_, _, _, radius} = nanobot, other) do
      manhattan_distance(nanobot, other) <= radius
    end

    def manhattan_distance({x1, y1, z1, _}, {x2, y2, z2, _}) do
      abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)
    end

    def parse(input) do
      input
      |> String.trim_trailing("\n")
      |> String.split("\n")
      |> Enum.map(&parse_line/1)
    end

    defp parse_line(line) do
      ~r/-?\d+/
      |> Regex.scan(line)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end
  end
end
