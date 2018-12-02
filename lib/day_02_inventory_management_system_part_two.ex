defmodule Adventofcode.Day02InventoryManagementSystem.PartTwo do
  use Adventofcode

  def common_letters(input) do
    input
    |> String.split("\n")
    |> do_common_letters
    |> hd
  end

  def do_common_letters(box_ids) do
    for a <- box_ids, b <- box_ids, off_by_one?(a, b) do
      common(a, b)
    end
  end

  defp off_by_one?(a, b) do
    diff(a, b) == 1
  end

  defp diff(a, b) do
    [a, b]
    |> Enum.map(&String.graphemes/1)
    |> transpose
    |> Enum.reject(fn [a, b] -> a == b end)
    |> Enum.count()
  end

  defp common(a, b) do
    [a, b]
    |> Enum.map(&String.graphemes/1)
    |> transpose
    |> Enum.filter(fn [a, b] -> a == b end)
    |> Enum.map(&hd/1)
    |> Enum.join("")
  end

  def transpose(list_of_lists) do
    list_of_lists
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
