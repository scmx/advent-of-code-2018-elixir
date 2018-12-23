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
