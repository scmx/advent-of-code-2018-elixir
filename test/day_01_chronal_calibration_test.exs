defmodule Adventofcode.Day01ChronalCalibrationTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day01ChronalCalibration

  describe "resulting_frequency/1" do
    test "+1, +1, +1 results in 3" do
      input = "+1, +1, +1"
      assert 3 = input |> resulting_frequency()
    end

    test "+1, +1, -2" do
      input = "+1, +1, -2"
      assert 0 = input |> resulting_frequency()
    end

    test "-1, -2, -3" do
      input = "-1, -2, -3"
      assert -6 = input |> resulting_frequency()
    end

    test_with_puzzle_input do
      assert 531 = puzzle_input() |> resulting_frequency()
    end
  end
end
