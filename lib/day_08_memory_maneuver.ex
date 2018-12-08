defmodule Adventofcode.Day08MemoryManeuver do
  use Adventofcode

  defstruct children_size: 0, metadata_size: 0, children: [], metadata: []

  def metadata_sum(input) do
    input
    |> parse
    |> traverse
    |> elem(0)
    |> do_metadata_sum
    |> Enum.sum()
  end

  defp do_metadata_sum(node) do
    children_metadata = Enum.flat_map(node.children, &do_metadata_sum/1)
    metadata = Tuple.to_list(node.metadata)
    children_metadata ++ metadata
  end

  defp traverse([]), do: nil

  defp traverse([children_size, metadata_size | tail]) do
    {%__MODULE__{children_size: children_size, metadata_size: metadata_size}, tail}
    |> traverse_children
    |> traverse_metadata
  end

  defp traverse_children({node, tail}) do
    if length(node.children) == node.children_size do
      {node, tail}
    else
      {child, rest} = traverse(tail)
      node = Map.update(node, :children, [], &(&1 ++ [child]))
      traverse_children({node, rest})
    end
  end

  def traverse_metadata({node, tail}) do
    {metadata, rest} = Enum.split(tail, node.metadata_size)

    {%{node | metadata: List.to_tuple(metadata)}, rest}
  end

  defp parse(input) do
    input
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end
end
