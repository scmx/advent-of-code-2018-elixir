defmodule Adventofcode.Day23ExperimentalEmergencyTeleportation.Part1Test do
  use Adventofcode.FancyCase

  import Adventofcode.Day23ExperimentalEmergencyTeleportation
  import Adventofcode.Day23ExperimentalEmergencyTeleportation.Part1

  @input """
  pos=<0,0,0>, r=4
  pos=<1,0,0>, r=1
  pos=<4,0,0>, r=3
  pos=<0,2,0>, r=1
  pos=<0,5,0>, r=3
  pos=<0,0,3>, r=1
  pos=<1,1,1>, r=1
  pos=<1,1,2>, r=1
  pos=<1,3,1>, r=1
  """

  describe "solve/1" do
    test "parses input nanobots coordinates and radiuses" do
      assert 7 = @input |> solve()
    end

    test_with_puzzle_input do
      assert 319 = puzzle_input() |> solve()
    end
  end
end

defmodule Adventofcode.Day23ExperimentalEmergencyTeleportation.Part2Test do
  use Adventofcode.FancyCase

  import Adventofcode.Day23ExperimentalEmergencyTeleportation
  import Adventofcode.Day23ExperimentalEmergencyTeleportation.Part2

  @input """
  pos=<10,12,12>, r=2
  pos=<12,14,12>, r=2
  pos=<16,12,12>, r=4
  pos=<14,14,14>, r=6
  pos=<50,50,50>, r=200
  pos=<10,10,10>, r=5
  """

  describe "solve/1" do
    test "parses input nanobots coordinates and radiuses" do
      assert 34 = @input |> solve()
    end

    @tag :slow
    test_with_puzzle_input do
      assert 319 = puzzle_input() |> solve()
    end
  end

  describe "coordinate_in_range_of_most_nanobots/1" do
    test "12,12,12 is in range of the most nanobots: the first five" do
      {coordinate, nanobots} = @input |> coordinate_in_range_of_most_nanobots()

      assert {12, 12, 12, _} = coordinate
      assert 5 == length(nanobots)
      assert 36 == distance_to_zero(coordinate)
    end
  end
end

defmodule Adventofcode.Day23ExperimentalEmergencyTeleportation.NanobotsTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day23ExperimentalEmergencyTeleportation.Nanobots

  @input """
  pos=<0,0,0>, r=4
  pos=<1,0,0>, r=1
  pos=<4,0,0>, r=3
  pos=<0,2,0>, r=1
  pos=<0,5,0>, r=3
  pos=<0,0,3>, r=1
  pos=<1,1,1>, r=1
  pos=<1,1,2>, r=1
  pos=<1,3,1>, r=1
  """

  describe "parse/1" do
    test "parses input nanobots coordinates and radiuses" do
      assert [
               {0, 0, 0, 4},
               {1, 0, 0, 1},
               {4, 0, 0, 3},
               {0, 2, 0, 1},
               {0, 5, 0, 3},
               {0, 0, 3, 1},
               {1, 1, 1, 1},
               {1, 1, 2, 1},
               {1, 3, 1, 1}
             ] = @input |> parse()
    end
  end
end
