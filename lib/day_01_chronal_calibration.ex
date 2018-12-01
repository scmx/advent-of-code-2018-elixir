defmodule Adventofcode.Day01ChronalCalibration do
  use Adventofcode

  def resulting_frequency(input) do
    input
    |> frequencies
    |> Enum.sum()
  end

  def first_frequency_repeated_twice(input) do
    input
    |> frequencies
    |> do_first_frequency_repeated_twice
  end

  defp frequencies(input) do
    input
    |> String.split(~r/\n|, /)
    |> Enum.map(&String.to_integer/1)
  end

  defp do_first_frequency_repeated_twice(
         changes,
         frequency \\ 0,
         index \\ 0,
         visited \\ MapSet.new()
       )

  defp do_first_frequency_repeated_twice(changes, frequency, index, visited) do
    frequency = frequency + Enum.at(changes, rem(index, length(changes)))

    if MapSet.member?(visited, frequency) do
      frequency
    else
      do_first_frequency_repeated_twice(
        changes,
        frequency,
        index + 1,
        MapSet.put(visited, frequency)
      )
    end
  end
end
