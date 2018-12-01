defmodule Adventofcode.Day01ChronalCalibration do
  use Adventofcode

  def resulting_frequency(input) do
    input
    |> parse
    |> Enum.sum()
  end

  def first_frequency_repeated_twice(input) do
    input
    |> parse
    |> Stream.cycle()
    |> reduce_until_repeated_twice
  end

  defp parse(input) do
    input
    |> String.split(~r/\n|, /)
    |> Enum.map(&String.to_integer/1)
  end

  defp reduce_until_repeated_twice(changes) do
    Enum.reduce_while(changes, {0, MapSet.new()}, fn change, {last, visited} ->
      resulting_frequency = last + change

      if MapSet.member?(visited, resulting_frequency) do
        {:halt, resulting_frequency}
      else
        {:cont, {resulting_frequency, MapSet.put(visited, resulting_frequency)}}
      end
    end)
  end
end
