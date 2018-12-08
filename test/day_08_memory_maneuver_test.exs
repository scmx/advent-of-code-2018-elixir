defmodule Adventofcode.Day08MemoryManeuverTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day08MemoryManeuver

  describe "metadata_sum/1" do
    @input "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
    test "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2" do
      assert 138 = @input |> metadata_sum()
    end

    test_with_puzzle_input do
      assert 45194 = puzzle_input() |> metadata_sum()
    end
  end
end
