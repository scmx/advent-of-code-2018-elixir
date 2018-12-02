defmodule Adventofcode.Day02InventoryManagementSystem do
  use Adventofcode

  alias Adventofcode.Day02InventoryManagementSystem.PartTwo

  defdelegate common_letters(input), to: PartTwo

  def checksum(input) do
    input
    |> String.split("\n")
    |> Enum.map(&letter_counts/1)
    |> count_box_ids_with_triplets_and_pairs
  end

  def letter_counts(input) do
    input
    |> String.graphemes()
    |> Enum.group_by(& &1)
    |> Enum.map(fn {letter, letters} -> {letter, length(letters)} end)
    |> Enum.filter(fn {_, count} -> count == 2 || count == 3 end)
    |> Enum.into(%{})
  end

  defp count_box_ids_with_triplets_and_pairs(letter_counts) do
    count_pairs(letter_counts) * count_triplets(letter_counts)
  end

  defp count_pairs(letter_counts) do
    letter_counts
    |> Enum.filter(&has_pairs?/1)
    |> Enum.count()
  end

  defp count_triplets(letter_counts) do
    letter_counts
    |> Enum.filter(&has_triplets?/1)
    |> Enum.count()
  end

  defp has_pairs?(letter_counts) do
    Enum.any?(letter_counts, fn {_, count} -> count == 2 end)
  end

  defp has_triplets?(letter_counts) do
    Enum.any?(letter_counts, fn {_, count} -> count == 3 end)
  end
end
