defmodule Adventofcode.Day16ChronalClassification do
  use Adventofcode

  defmodule Part1 do
    alias Adventofcode.Day16ChronalClassification.Samples

    def solve(input) do
      input
      |> Samples.detect_matching_operations()
      |> Enum.filter(&three_or_more_matching_operations?/1)
      |> Enum.count()
    end

    defp three_or_more_matching_operations?({_opcode, operation_names}) do
      length(operation_names) >= 3
    end
  end

  defmodule Part2 do
    alias Adventofcode.Day16ChronalClassification.{Classification, Samples}

    def solve(input) do
      input
      |> map_opcodes_to_operation_names()
      |> run_test_program(parse_test_program(input))
      |> Map.get(0)
    end

    def map_opcodes_to_operation_names(input) do
      input
      |> Samples.detect_matching_operations()
      |> do_map_opcodes([], %{}, length(Classification.operation_names()))
    end

    defp do_map_opcodes(items, rest, acc, expected_count)

    # Done if there's nothing left to map
    defp do_map_opcodes([], [], acc, _), do: acc

    # Done if all codes have been mapped
    defp do_map_opcodes(_, _, acc, goal) when map_size(acc) == goal, do: acc

    # Wrap around and check rest when items have all been checked
    defp do_map_opcodes([], rest, acc, goal) do
      do_map_opcodes(Enum.reverse(rest), [], acc, goal)
    end

    # Found opcode with only a sinle match, collect and eliminate possibilities
    defp do_map_opcodes([{opcode, [name]} | tail], rest, acc, goal) do
      tail
      |> eliminate_possibilities(opcode, name)
      |> do_map_opcodes(rest, Map.put(acc, opcode, name), goal)
    end

    # Nothing can be done with this one, check the next one
    defp do_map_opcodes([head | tail], rest, acc, goal) do
      do_map_opcodes(tail, [head | rest], acc, goal)
    end

    defp eliminate_possibilities(opcodes, opcode, name) do
      opcodes
      |> Enum.reject(fn {code, _} -> code == opcode end)
      |> Enum.map(fn {code, names} -> {code, names -- [name]} end)
    end

    defp run_test_program(opcode_mapper, test_program) do
      Enum.reduce(test_program, %{}, fn {opcode, a, b, c}, acc ->
        operation_name = Map.fetch!(opcode_mapper, opcode)

        apply(Classification, operation_name, [a, b, c, acc])
      end)
    end

    defp parse_test_program(input) do
      input
      |> String.split("\n\n\n")
      |> Enum.at(1)
      |> String.trim("\n")
      |> String.split("\n")
      |> Enum.map(&Samples.parse_line/1)
    end
  end

  defmodule Samples do
    alias Adventofcode.Day16ChronalClassification.Classification

    def detect_matching_operations(input) do
      Enum.map(parse(input), fn {input, {opcode, a, b, c}, expected} ->
        {opcode, matching_operations({input, {opcode, a, b, c}, expected})}
      end)
    end

    defp matching_operations({input, instruction, expected}) do
      state = tuple_to_map(input)
      expected = tuple_to_map(expected)

      Classification.operation_names()
      |> Enum.filter(&matching_operation?(&1, state, instruction, expected))
    end

    defp matching_operation?(operation_name, state, instruction, expected) do
      apply_operation(operation_name, instruction, state) == expected
    end

    defp apply_operation(operation_name, {_code, a, b, c}, state) do
      apply(Classification, operation_name, [a, b, c, state])
    end

    defp tuple_to_map(tuple) do
      tuple
      |> Tuple.to_list()
      |> Enum.with_index()
      |> Enum.map(fn {value, index} -> {index, value} end)
      |> Enum.into(%{})
    end

    def parse(input) do
      input
      |> String.split("\n\n\n")
      |> hd()
      |> String.trim_trailing("\n")
      |> String.split("\n\n")
      |> Enum.map(&parse_sample/1)
    end

    defp parse_sample(sample_input) do
      sample_input
      |> String.split("\n")
      |> Enum.map(&parse_line/1)
      |> List.to_tuple()
    end

    def parse_line(line) do
      ~r/\d+/
      |> Regex.scan(line)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end
  end

  defmodule Classification do
    use Bitwise

    def operation_names do
      __info__(:functions)
      |> Enum.filter(fn {_name, arity} -> arity == 4 end)
      |> Enum.map(fn {name, _arity} -> name end)
    end

    def operation_functions do
      Enum.map(operation_names(), &Function.capture(__MODULE__, &1, 4))
    end

    def addr(a, b, c, state) do
      Map.put(state, c, Map.get(state, a, 0) + Map.get(state, b, 0))
    end

    def addi(a, b, c, state) do
      Map.put(state, c, Map.get(state, a, 0) + b)
    end

    def mulr(a, b, c, state) do
      Map.put(state, c, Map.get(state, a, 0) * Map.get(state, b, 0))
    end

    def muli(a, b, c, state) do
      Map.put(state, c, Map.get(state, a, 0) * b)
    end

    def banr(a, b, c, state) do
      Map.put(state, c, band(Map.get(state, a, 0), Map.get(state, b, 0)))
    end

    def bani(a, b, c, state) do
      Map.put(state, c, band(Map.get(state, a, 0), b))
    end

    def borr(a, b, c, state) do
      Map.put(state, c, bor(Map.get(state, a, 0), Map.get(state, b, 0)))
    end

    def bori(a, b, c, state) do
      Map.put(state, c, bor(Map.get(state, a, 0), b))
    end

    def setr(a, _b, c, state) do
      Map.put(state, c, Map.get(state, a, 0))
    end

    def seti(a, _b, c, state) do
      Map.put(state, c, a)
    end

    def gtir(a, b, c, state) do
      Map.put(state, c, if(a > Map.get(state, b, 0), do: 1, else: 0))
    end

    def gtri(a, b, c, state) do
      Map.put(state, c, if(Map.get(state, a, 0) > b, do: 1, else: 0))
    end

    def gtrr(a, b, c, state) do
      value = if(Map.get(state, a, 0) > Map.get(state, b, 0), do: 1, else: 0)

      Map.put(state, c, value)
    end

    def eqir(a, b, c, state) do
      Map.put(state, c, if(a == Map.get(state, b, 0), do: 1, else: 0))
    end

    def eqri(a, b, c, state) do
      Map.put(state, c, if(Map.get(state, a, 0) == b, do: 1, else: 0))
    end

    def eqrr(a, b, c, state) do
      value = if(Map.get(state, a, 0) == Map.get(state, b, 0), do: 1, else: 0)

      Map.put(state, c, value)
    end
  end
end
