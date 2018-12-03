defmodule Adventofcode.Day03NoMatterHowYouSliceItTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day03NoMatterHowYouSliceIt

  describe "Adventofcode.Day03NoMatterHowYouSliceIt.parse/1" do
    test "parsing #1 @ 1,3: 4x4" do
      assert %Adventofcode.Day03NoMatterHowYouSliceIt{
               id: 1,
               offset: {1, 3},
               size: {4, 4},
               fabric: [
                 {1, 3},
                 {2, 3},
                 {3, 3},
                 {4, 3},
                 {1, 4},
                 {2, 4},
                 {3, 4},
                 {4, 4},
                 {1, 5},
                 {2, 5},
                 {3, 5},
                 {4, 5},
                 {1, 6},
                 {2, 6},
                 {3, 6},
                 {4, 6}
               ]
             } = parse_claim("#1 @ 1,3: 4x4")
    end

    test "parsing #2 @ 3,1: 4x4" do
      assert %Adventofcode.Day03NoMatterHowYouSliceIt{
               id: 2,
               offset: {3, 1},
               size: {4, 4},
               fabric: [
                 {3, 1},
                 {4, 1},
                 {5, 1},
                 {6, 1},
                 {3, 2},
                 {4, 2},
                 {5, 2},
                 {6, 2},
                 {3, 3},
                 {4, 3},
                 {5, 3},
                 {6, 3},
                 {3, 4},
                 {4, 4},
                 {5, 4},
                 {6, 4}
               ]
             } = parse_claim("#2 @ 3,1: 4x4")
    end

    test "parsing #3 @ 5,5: 2x2" do
      assert %Adventofcode.Day03NoMatterHowYouSliceIt{
               id: 3,
               offset: {5, 5},
               size: {2, 2},
               fabric: [{5, 5}, {6, 5}, {5, 6}, {6, 6}]
             } = parse_claim("#3 @ 5,5: 2x2")
    end
  end

  describe "overlapping_fabric/1" do
    @input """
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """
    test "four square inches are claimed by both 1 and 2" do
      assert 4 = @input |> overlapping_fabric()
    end

    test_with_puzzle_input do
      assert 110_827 = puzzle_input() |> overlapping_fabric()
    end
  end
end
