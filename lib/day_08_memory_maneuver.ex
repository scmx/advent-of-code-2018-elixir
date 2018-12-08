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

  def root_value(input) do
    input
    |> parse
    |> traverse
    |> elem(0)
    |> do_root_value
    |> Enum.sum()
  end

  defp do_metadata_sum(node) do
    children_metadata = Enum.flat_map(node.children, &do_metadata_sum/1)
    metadata = Tuple.to_list(node.metadata)
    children_metadata ++ metadata
  end

  defp do_root_value(%{children_size: 0} = node) do
    node.metadata
    |> Tuple.to_list()
    |> Enum.sum()
    |> List.wrap()
  end

  defp do_root_value(node) do
    Enum.flat_map(Tuple.to_list(node.metadata), fn index ->
      case Enum.at([nil | node.children], index) do
        nil -> []
        child -> do_root_value(child)
      end
    end)
  end

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
