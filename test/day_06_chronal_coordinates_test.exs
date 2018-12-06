defmodule Adventofcode.Day06ChronalCoordinatesTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day06ChronalCoordinates

  @coordinates """
  1, 1
  1, 6
  8, 3
  3, 4
  5, 5
  8, 9
  """

  describe "manhattan_distance/2" do
    test "distance between 0,0 and 1,1 is 2" do
      assert 2 = manhattan_distance({0, 0}, {1, 1})
    end

    test "distance between 8,9 and 1,1 is 15 (=8-1+9-1)" do
      assert 15 = manhattan_distance({8, 9}, {1, 1})
    end

    test "distance between 1,1 and 8,9 is 15 (=8-1+9-1)" do
      assert 15 = manhattan_distance({8, 9}, {1, 1})
    end
  end

  @parsed_coordinates [{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}]

  describe "parse_coordinates/1" do
    test "returns grid of all parsed coordinates" do
      assert @parsed_coordinates == @coordinates |> parse_coordinates
    end
  end

  describe "names/0" do
    test "returns list of AA .. ZZ coordinate names" do
      assert ["0A", "0B", "0C" | _] = names()
      assert ["1Z", "1Y", "1X" | _] = Enum.reverse(names())
    end
  end
end
