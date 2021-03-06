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

  describe "largest_area_size/1" do
    test "the size of the largest area is 17" do
      assert 17 = @coordinates |> largest_area_size()
    end

    test_with_puzzle_input do
      assert 4143 = puzzle_input() |> largest_area_size()
    end
  end

  describe "safe_area_size/2" do
    test "the size of the largest area is 17" do
      assert 16 = @coordinates |> safe_area_size(32)
    end

    test_with_puzzle_input do
      assert 35039 = puzzle_input() |> safe_area_size(10000)
    end
  end

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

  @built_grid %{
    {1, 1} => "0A",
    {1, 6} => "0B",
    {8, 3} => "0C",
    {3, 4} => "0D",
    {5, 5} => "0E",
    {8, 9} => "0F"
  }

  describe "build_grid/1" do
    test "returns a map with all coordinates" do
      assert @built_grid == build_grid(@parsed_coordinates)
    end
  end

  describe "names/0" do
    test "returns list of AA .. ZZ coordinate names" do
      assert ["0A", "0B", "0C" | _] = names()
      assert ["1Z", "1Y", "1X" | _] = Enum.reverse(names())
    end
  end

  describe "grid_locations/0" do
    test "returns all locations in grid" do
      assert [{0, 0}, {0, 1}, {0, 2} | _] = grid_locations(0..9)
      assert [{9, 9}, {9, 8}, {9, 7} | _] = Enum.reverse(grid_locations(0..9))
    end
  end

  describe "closest_coordinate/1" do
    test "returns closest coordinate for a location and grid" do
      assert "0d" = closest_coordinate({4, 2}, @built_grid)
      assert ".." = closest_coordinate({1, 4}, @built_grid)
    end
  end

  describe "distance_to_all_coordinates/2" do
    test "sums the distances to all coordinates from a location" do
      assert 30 = distance_to_all_coordinates({4, 3}, @built_grid)
    end
  end

  describe "closest_coordinates/1" do
    @expected_grid """
    0a0a0a0a0a..0c0c0c0c
    0a0a0a0a0a..0c0c0c0c
    0a0a0a0d0d0e0c0c0c0c
    0a0a0d0d0d0e0c0c0c0c
    ....0d0d0d0e0e0c0c0c
    0b0b..0d0e0e0e0e0c0c
    0b0b0b..0e0e0e0e....
    0b0b0b..0e0e0e0f0f0f
    0b0b0b..0e0e0f0f0f0f
    0b0b0b..0f0f0f0f0f0f
    """
    test "returns grid where each location knows closest coordinate" do
      result = @built_grid |> closest_coordinates(grid_locations(0..9))

      expected = String.trim(@expected_grid, "\n")
      actual = pretty_grid(result)

      assert actual == expected
    end
  end

  def print_grid(grid) do
    grid
    |> pretty_grid
    |> IO.puts()
  end

  def pretty_grid(grid, range \\ 0..9) do
    Enum.map_join(range, "\n", fn y ->
      Enum.map_join(range, "", fn x ->
        grid[{x, y}]
      end)
    end)
  end
end
