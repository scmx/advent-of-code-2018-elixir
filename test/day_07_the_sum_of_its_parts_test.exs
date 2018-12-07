defmodule Adventofcode.Day07TheSumOfItsPartsTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day07TheSumOfItsParts
  import ExUnit.CaptureIO

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

  describe "steps_completion_time/2" do
    test "15" do
      assert 15 = @input |> steps_completion_time(workers: 2, delay: 0)
    end

    test_with_puzzle_input do
      options = [workers: 5, delay: 60, print: true]

      assert 1337 = puzzle_input() |> steps_completion_time(options)
    end

    @table """
    Second   Worker 1   Worker 2   Done
       0        C          .       
       1        C          .       
       2        C          .       
       3        A          F       C
       4        B          F       CA
       5        B          F       CA
       6        D          F       CAB
       7        D          F       CAB
       8        D          F       CAB
       9        D          .       CABF
      10        E          .       CABFD
      11        E          .       CABFD
      12        E          .       CABFD
      13        E          .       CABFD
      14        E          .       CABFD
      15        .          .       CABFDE
    """
    test "table matches" do
      options = [workers: 2, delay: 0, print: true]

      fun = fn ->
        assert 15 = @input |> steps_completion_time(options)
      end

      table = fun |> capture_io |> String.trim_leading("\n")

      assert @table == table
    end
  end

  describe "time_needed/1" do
    test "determines time needed for task based on name" do
      assert 1 = "A" |> time_needed
      assert 2 = "B" |> time_needed
      assert 3 = "C" |> time_needed
      assert 4 = "D" |> time_needed
      assert 5 = "E" |> time_needed
      assert 6 = "F" |> time_needed
    end
  end

  describe "build_dependencies/1" do
    test "determines time needed for task based on name" do
      input = [
        ["C", "A"],
        ["C", "F"],
        ["A", "B"],
        ["A", "D"],
        ["B", "E"],
        ["D", "E"],
        ["F", "E"]
      ]

      expected = %{
        "A" => ["C"],
        "B" => ["A"],
        "C" => [],
        "D" => ["A"],
        "E" => ["F", "D", "B"],
        "F" => ["C"]
      }

      assert expected == input |> build_dependencies
    end
  end
end
