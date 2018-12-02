defmodule Adventofcode.Day02InventoryManagementSystemTest do
  use Adventofcode.FancyCase

  import Adventofcode.Day02InventoryManagementSystem

  describe "letter_counts/1" do
    test "abcdef contains no letters that appear exactly two or three times." do
      input = "abcdef"
      assert %{} == input |> letter_counts()
    end

    test "bababc contains two a and three b, so it counts for both." do
      input = "bababc"
      assert %{"a" => 2, "b" => 3} = input |> letter_counts()
    end

    test "abbcde contains two b, but no letter appears exactly three times." do
      input = "abbcde"
      assert %{"b" => 2} = input |> letter_counts()
    end

    test "abcccd contains three c, but no letter appears exactly two times." do
      input = "abcccd"
      assert %{"c" => 3} = input |> letter_counts()
    end

    test "aabcdd contains two a and two d, but it only counts once." do
      input = "aabcdd"
      assert %{"a" => 2, "d" => 2} = input |> letter_counts()
    end

    test "abcdee contains two e." do
      input = "abcdee"
      assert %{"e" => 2} = input |> letter_counts()
    end

    test "ababab contains three a and three b, but it only counts once." do
      input = "ababab"
      assert %{"a" => 3, "b" => 3} = input |> letter_counts()
    end
  end

  describe "checksum/1" do
    # Of these box IDs, four of them contain a letter which appears exactly
    # twice, and three of them contain a letter which appears exactly three
    # times. Multiplying these together produces a checksum of 4 * 3 = 12
    @input """
    abcdef
    bababc
    abbcde
    abcccd
    aabcdd
    abcdee
    ababab
    """
    test "Multiplying these together produces a checksum of 4 * 3 = 12" do
      assert 12 = @input |> checksum()
    end

    test_with_puzzle_input do
      assert 6888 = puzzle_input() |> checksum()
    end
  end

  describe "common_letters/1" do
    @input """
    abcde
    fghij
    klmno
    pqrst
    fguij
    axcye
    wvxyz
    """
    test "fghij and fguij differ by exactly one character, resulting in fgijv" do
      assert "fgij" = @input |> common_letters()
    end

    test_with_puzzle_input do
      assert "icxjvbrobtunlelzpdmfkahgs" = puzzle_input() |> common_letters()
    end
  end
end
