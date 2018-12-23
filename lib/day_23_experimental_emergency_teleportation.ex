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
