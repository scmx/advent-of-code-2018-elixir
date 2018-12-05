defmodule Adventofcode.Day05AlchemicalReactionTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day05AlchemicalReaction

  describe "remaining_units/1" do
    test "In aA, a and A react, leaving nothing behind" do
      assert "" = "aA" |> remaining_units()
    end

    test "In abBA, bB destroys itself, aA destroys itself, leaving nothing" do
      assert "" = "abBA" |> remaining_units()
    end

    test "In abAB, no two adjacent of the same type, and so nothing happens" do
      assert "abAB" = "abAB" |> remaining_units()
    end

    test "In aabAAB, their polarities match, and so nothing happens" do
      assert "aabAAB" = "aabAAB" |> remaining_units()
    end

    test_with_puzzle_input do
      assert "" = puzzle_input() |> remaining_units()
    end
  end
end
