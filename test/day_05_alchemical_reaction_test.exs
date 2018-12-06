defmodule Adventofcode.Day05AlchemicalReactionTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day05AlchemicalReaction

  describe "remaining_units/1" do
    test_with_puzzle_input do
      assert 11152 = puzzle_input() |> remaining_units()
    end
  end

  describe "improved_remaining_units/1" do
    test "dabAcCaCBAcCcaDA" do
      assert 4 = "dabAcCaCBAcCcaDA" |> improved_remaining_units()
    end

    test_with_puzzle_input do
      assert 6136 = puzzle_input() |> improved_remaining_units()
    end
  end

  describe "apply_reductions/1" do
    test "In aA, a and A react, leaving nothing behind" do
      assert "" = "aA" |> apply_reductions()
    end

    test "In abBA, bB destroys itself, aA destroys itself, leaving nothing" do
      assert "" = "abBA" |> apply_reductions()
    end

    test "In abAB, no two adjacent of the same type, and so nothing happens" do
      assert "abAB" = "abAB" |> apply_reductions()
    end

    test "In aabAAB, their polarities match, and so nothing happens" do
      assert "aabAAB" = "aabAAB" |> apply_reductions()
    end

    test "Now, consider a larger example, dabAcCaCBAcCcaDA" do
      assert "dabCBAcaDA" = "dabAcCaCBAcCcaDA" |> apply_reductions
    end
  end
end
