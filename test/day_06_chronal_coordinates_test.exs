defmodule Adventofcode.Day06ChronalCoordinatesTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day06ChronalCoordinates

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
end
