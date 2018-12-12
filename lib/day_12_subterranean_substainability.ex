defmodule Adventofcode.Day12SubterraneanSubstainability do
  use Adventofcode

  @default_generations 20
  @default_view {-3, 36}
  @initial_state_regex ~r/^initial state: ([\.\#]+)/
  @patterns_regex ~r/^([\.\#]+) => \#$/m

  defstruct(
    generation: {0, @default_generations},
    view: @default_view,
    pots: "",
    patterns: [],
    stabilized: false,
    total: 0,
    print: false
  )

  def total_plants(input, options \\ []) do
    input
    |> new(options)
    |> process
    |> Map.get(:total)
  end

  def new(input, options \\ []) do
    patterns = input |> parse_patterns()
    generation = {0, Keyword.get(options, :generation, @default_generations)}
    view = Keyword.get(options, :view, @default_view)
    print = Keyword.get(options, :print, false)

    %__MODULE__{generation: generation, view: view, patterns: patterns, print: print}
    |> build_pots(input)
    |> update_total
    |> print
  end

  def process(%{generation: {last, last}} = state), do: state

  def process(%{stabilized: true} = state) do
    state
    |> fast_forward
    |> update_total
    |> print()
    |> process()
  end

  def process(state) do
    state
    |> update_pots
    |> update_generation
    |> update_total
    |> detect_stabilized(state.pots)
    |> print()
    |> process()
  end

  def detect_stabilized(%{stabilized: true} = state, _pots_before), do: state

  def detect_stabilized(state, pots_before) do
    if state.pots <> "." == "." <> pots_before do
      Map.put(state, :stabilized, true)
    else
      state
    end
  end

  def fast_forward(state) do
    %{generation: {current, last}, view: {x1, x2}} = state

    jump = last - current

    %{state | generation: {last, last}, view: {x1 + jump, x2 + jump}}
  end

  defp update_pots(state) do
    Map.update(state, :pots, "", &next_pots(&1, state.patterns))
  end

  def next_pots(pots, patterns) do
    pots
    |> String.graphemes()
    |> chunk_with_neighbours(5)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.map(&next_plant(&1, patterns))
    |> Enum.join("")
  end

  def print(%{print: false} = state), do: state

  def print(state) do
    IO.puts(String.pad_leading(to_string(elem(state.generation, 0)), 2) <> ": #{state.pots}")
    state
  end

  defp update_generation(state) do
    Map.update(state, :generation, nil, fn {gen, last} -> {gen + 1, last} end)
  end

  defp update_total(state) do
    Map.put(state, :total, plant_count(state))
  end

  def plant_count(state) do
    state.pots
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.filter(&(elem(&1, 0) == "#"))
    |> Enum.map(&(elem(&1, 1) + elem(state.view, 0)))
    |> Enum.sum()
  end

  defp next_plant(pots, patterns) do
    Enum.find_value(patterns, ".", fn pattern ->
      case pots do
        ^pattern -> "#"
        _ -> nil
      end
    end)
  end

  defp build_pots(state, input) do
    Map.put(state, :pots, input |> parse_pots |> pad_around_pots(state))
  end

  defp parse_pots(input) do
    @initial_state_regex
    |> Regex.run(input)
    |> Enum.at(1)
  end

  defp parse_patterns(input) do
    @patterns_regex
    |> Regex.scan(input)
    |> Enum.map(&Enum.at(&1, 1))
  end

  defp pad_around_pots(pots, state) do
    prefix_size = abs(elem(state.view, 0))
    prefix = String.pad_leading("", prefix_size, ".")

    suffix_size = elem(state.view, 1) - String.length(pots)
    suffix = String.pad_trailing("", suffix_size, ".")

    prefix <> pots <> suffix
  end

  def chunk_with_neighbours(items, count) do
    border = List.duplicate(".", div(count, 2))

    Enum.chunk_every(border ++ items ++ border, count, 1, :discard)
  end
end
