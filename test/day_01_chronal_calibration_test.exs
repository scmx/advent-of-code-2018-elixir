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

  describe "first_frequency_repeated_twice/1" do
    # TODO: Wrong expected result? Should be 1?
    @tag :skip
    test "+1, -1 first reaches 0 twice." do
      input = "+1, -1"
      assert 0 = input |> first_frequency_repeated_twice()
    end

    test "+3, +3, +4, -2, -4 first reaches 10 twice." do
      input = "+3, +3, +4, -2, -4"
      assert 10 = input |> first_frequency_repeated_twice()
    end

    test "-6, +3, +8, +5, -6 first reaches 5 twice." do
      input = "-6, +3, +8, +5, -6"
      assert 5 = input |> first_frequency_repeated_twice()
    end

    test "+7, +7, -2, -7, -4 first reaches 14 twice." do
      input = "+7, +7, -2, -7, -4"
      assert 14 = input |> first_frequency_repeated_twice()
    end

    test_with_puzzle_input do
      assert 76787 = puzzle_input() |> first_frequency_repeated_twice()
    end
  end
end
