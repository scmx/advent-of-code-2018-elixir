defmodule Adventofcode.Day01ChronalCalibration do
  use Adventofcode

  def resulting_frequency(input) do
    input
    |> String.split(~r/\n|, /)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end
