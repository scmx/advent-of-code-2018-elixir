defmodule Adventofcode.Day11ChronalChargeTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day11ChronalCharge

  describe "most_powered_three_by_three/1" do
    test "top-left fuel cell of the 3x3 square with the largest total power" do
      assert "21,61" = 42 |> most_powered_three_by_three()
    end

    test_with_puzzle_input do
      assert "21,41" = puzzle_input() |> most_powered_three_by_three()
    end
  end

  describe "most_powered_any_size/1" do
    test "identifier of the square with the largest total power" do
      assert "90,269,16" = 18 |> most_powered_any_size
      assert "232,251,12" = 42 |> most_powered_any_size
    end

    test_with_puzzle_input do
      assert "227,199,19" = puzzle_input() |> most_powered_any_size()
    end
  end
end
