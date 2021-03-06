defmodule Adventofcode.Day12SubterraneanSubstainabilityTest do
  use Adventofcode.FancyCase

  alias Adventofcode.Day12SubterraneanSubstainability

  import Adventofcode.Day12SubterraneanSubstainability
  import ExUnit.CaptureIO

  @input """
  initial state: #..#.#..##......###...###

  ...## => #
  ..#.. => #
  .#... => #
  .#.#. => #
  .#.## => #
  .##.. => #
  .#### => #
  #.#.# => #
  #.### => #
  ##.#. => #
  ##.## => #
  ###.. => #
  ###.# => #
  ####. => #
  """

  describe "new/1" do
    test "parses input initial state and spread patterns" do
      expected = %Day12SubterraneanSubstainability{
        generation: {0, 20},
        patterns: [
          "...##",
          "..#..",
          ".#...",
          ".#.#.",
          ".#.##",
          ".##..",
          ".####",
          "#.#.#",
          "#.###",
          "##.#.",
          "##.##",
          "###..",
          "###.#",
          "####."
        ],
        pots: "...#..#.#..##......###...###...........",
        print: false,
        total: 145,
        view: {-3, 36}
      }

      assert ^expected = new(@input)
    end
  end

  describe "next_pots/1" do
    test "determines whether pots should contain a plant based on patterns" do
      patterns = new(@input).patterns

      [input_pots, expected] = [
        "...............#..#.#..##......###...###...............",
        "...............#...#....#.....#..#..#..#..............."
      ]

      assert ^expected = input_pots |> next_pots(patterns)
    end
  end

  describe "total_plants/2" do
    @expected_output """
     0: ...#..#.#..##......###...###...........
     1: ...#...#....#.....#..#..#..#...........
     2: ...##..##...##....#..#..#..##..........
     3: ..#.#...#..#.#....#..#..#...#..........
     4: ...#.#..#...#.#...#..#..##..##.........
     5: ....#...##...#.#..#..#...#...#.........
     6: ....##.#.#....#...#..##..##..##........
     7: ...#..###.#...##..#...#...#...#........
     8: ...#....##.#.#.#..##..##..##..##.......
     9: ...##..#..#####....#...#...#...#.......
    10: ..#.#..#...#.##....##..##..##..##......
    11: ...#...##...#.#...#.#...#...#...#......
    12: ...##.#.#....#.#...#.#..##..##..##.....
    13: ..#..###.#....#.#...#....#...#...#.....
    14: ..#....##.#....#.#..##...##..##..##....
    15: ..##..#..#.#....#....#..#.#...#...#....
    16: .#.#..#...#.#...##...#...#.#..##..##...
    17: ..#...##...#.#.#.#...##...#....#...#...
    18: ..##.#.#....#####.#.#.#...##...##..##..
    19: .#..###.#..#.#.#######.#.#.#..#.#...#..
    20: .#....##....#####...#######....#.#..##.
    """
    test "determines plants for every generation and sums total number" do
      fun = fn ->
        result = @input |> total_plants(print: true)

        send(self(), {:result, result})
      end

      actual_output = capture_io(fun)

      assert actual_output == @expected_output
      assert_received {:result, 325}
    end

    @expected_output """
     0: ..#..####.##..#.##.#..#.....##..#.###.#..###....##.##.#.#....#.##.####.#..##.###.#.......#....................
     1: ..#..#.##..#.....#....##...#.#....#.#....#.....#.#..#.##.#......#.#.##.....#.#.#..#......##...................
     2: ..#.....#..##....##..#.#.#..#.#....#.#...##.....#......#..#......##..#......###...##....#.#...................
     3: ..##....#...#...#.#...###....#.#....#.###.#.....##.....#..##....#.#..##....##...##.#.....#.#..................
     4: .#.#....###.###..#.####.......#.#.....#.#..#...#.#.....#...#.....#....#...#.#.##.#..#.....#.#.................
     5: ..#.#..##.#.#......#.#.........#.#.....#...###..#.#....###.##....##...###..##..#....##.....#.#................
     6: ...#....#.##.#......#.#.........#.#....#####.....#.#..##.#..#...#.#.###.....#..##..#.#......#.#...............
     7: ...##......#..#......#.#.........#.#..##.##.......#....#....###..##.#.......#...#...#.#......#.#..............
     8: ..#.#......#..##......#.#.........#....#..#.......##...##..##.....#..#......###.###..#.#......#.#.............
     9: ...#.#.....#...#.......#.#........##...#..##.....#.#.##.#...#.....#..##....##.#.#.....#.#......#.#............
    10: ....#.#....###.##.......#.#......#.#.#.#...#......##..#..##.##....#...#...#.#.##.#.....#.#......#.#...........
    11: .....#.#..##.#..#........#.#......#####.##.##....#.#..#...#..#....###.###..##..#..#.....#.#......#.#..........
    12: ......#....#....##........#.#....##.###..#..#.....#...###.#..##..##.#.#.....#..#..##.....#.#......#.#.........
    13: ......##...##..#.#.........#.#..#.#.#....#..##....#####.#.....#...#.##.#....#..#...#......#.#......#.#........
    14: .....#.#.##.#...#.#.........#....###.#...#...#...##.###..#....###....#..#...#..###.##......#.#......#.#.......
    15: ......##..#..##..#.#........##..##.#..##.###.####.#.#....##..##......#..###.#..#.#..#.......#.#......#.#......
    16: .....#.#..#...#...#.#......#.#...#.....#.#.#.#.##.##.#..#.#...#......#..#.#.....#...##.......#.#......#.#.....
    17: ......#...###.###..#.#......#.##.##.....######..#..#.....#.##.##.....#...#.#....####.#........#.#......#.#....
    18: ......#####.#.#.....#.#........#..#....##.###...#..##.......#..#.....###..#.#..##.##..#........#.#......#.#...
    19: .....##.###.##.#.....#.#.......#..##..#.#.#...#.#...#.......#..##...##.....#....#..#..##........#.#......#.#..
    20: ....#.#.#.#..#..#.....#.#......#...#...###.##..#.##.##......#...#.##.#.....##...#..#...#.........#.#......#.#.
    """
    test_with_puzzle_input do
      options = [generation: 20, view: {-2, 108}, print: true]

      fun = fn ->
        result = puzzle_input() |> total_plants(options)

        send(self(), {:result, result})
      end

      actual_output = capture_io(fun)

      assert_received {:result, 1696}
      assert actual_output == @expected_output
    end
  end

  test_with_puzzle_input "fifty billion generations" do
    options = [generation: 50_000_000_000, view: {-2, 500}]

    assert 1_799_999_999_458 = puzzle_input() |> total_plants(options)
  end

  describe "chunk_with_neighbours/2" do
    test "chunks each character with the two left and two right beside it" do
      expected = [
        [".", ".", "#", ".", "#"],
        [".", "#", ".", "#", "#"],
        ["#", ".", "#", "#", "."],
        [".", "#", "#", ".", "."]
      ]

      assert ^expected = ["#", ".", "#", "#"] |> chunk_with_neighbours(5)
    end
  end

  describe "fast_forward/1" do
    test "fast forwards a stabilized state to last generation" do
      state = %Day12SubterraneanSubstainability{
        generation: {0, 20},
        patterns: [
          "...##",
          "..#..",
          ".#...",
          ".#.#.",
          ".#.##",
          ".##..",
          ".####",
          "#.#.#",
          "#.###",
          "##.#.",
          "##.##",
          "###..",
          "###.#",
          "####."
        ],
        pots: "...#..#.#..##......###...###...........",
        print: false,
        stabilized: true,
        total: 145,
        view: {-3, 36}
      }

      assert %{view: {17, 56}} = fast_forward(state)
    end
  end
end
