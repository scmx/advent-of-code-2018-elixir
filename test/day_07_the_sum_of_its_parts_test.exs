defmodule Adventofcode.Day07TheSumOfItsPartsTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day07TheSumOfItsParts

  describe "parse_step/1" do
    test "parses step into tuple of two letters" do
      input = "Step C must be finished before step A can begin."
      assert ["C", "A"] = input |> parse_step()
    end
  end

  @input """
  Step C must be finished before step A can begin.
  Step C must be finished before step F can begin.
  Step A must be finished before step B can begin.
  Step A must be finished before step D can begin.
  Step B must be finished before step E can begin.
  Step D must be finished before step E can begin.
  Step F must be finished before step E can begin.
  """

  describe "steps_in_order/1" do
    test "CABDFE" do
      assert "CABDFE" = @input |> steps_in_order()
    end

    test_with_puzzle_input do
      assert "ADEFKLBVJQWUXCNGORTMYSIHPZ" = puzzle_input() |> steps_in_order()
    end
  end
end
