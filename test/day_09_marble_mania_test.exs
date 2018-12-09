defmodule Adventofcode.Day09MarbleManiaTest do
  use Adventofcode.FancyCase

  alias Adventofcode.Circle

  import Adventofcode.Day09MarbleMania

  describe "winning_score/1" do
    test "9 players; last marble is worth 25 points: high score is 32" do
      assert 32 = "9 players; last marble is worth 25 points" |> winning_score()
    end

    test "10 players; last marble is worth 1618 points: high score is 8317" do
      assert 8317 = "10 players; last marble is worth 1618 points" |> winning_score()
    end

    test "13 players; last marble is worth 7999 points: high score is 146373" do
      assert 146_373 = "13 players; last marble is worth 7999 points" |> winning_score()
    end

    test "17 players; last marble is worth 1104 points: high score is 2764" do
      assert 2764 = "17 players; last marble is worth 1104 points" |> winning_score()
    end

    test "21 players; last marble is worth 6111 points: high score is 54718" do
      assert 54718 = "21 players; last marble is worth 6111 points" |> winning_score()
    end

    test "30 players; last marble is worth 5807 points: high score is 37305" do
      assert 37305 = "30 players; last marble is worth 5807 points" |> winning_score()
    end

    test_with_puzzle_input do
      assert 386_151 = puzzle_input() |> winning_score()
    end
  end

  @tag :slow
  describe "winning_score_times_hundred/1" do
    test_with_puzzle_input do
      assert 3_211_264_152 = puzzle_input() |> winning_score_times_hundred()
    end
  end

  describe "assign_score_to_player/1" do
    test "player score(1) increases by turn(2) and current marble(2)" do
      state = %{
        marbles: Circle.new() |> Circle.insert_next(2),
        players: {0, 1, 0},
        turn: 2
      }

      assert %{players: {0, 5, 0}} = assign_score_to_player(state)
    end
  end

  test "player_index/1" do
    assert 0 = player_index(%{players: {0, 0}, turn: 1})
    assert 1 = player_index(%{players: {0, 0}, turn: 2})
    assert 0 = player_index(%{players: {0, 0}, turn: 3})

    assert 0 = player_index(%{players: {0, 0, 0}, turn: 1})
    assert 0 = player_index(%{players: {0, 0, 0}, turn: 4})
  end

  test "update_elem/3" do
    assert {2} = {1} |> update_elem(0, &(&1 + 1))
    assert {2} = {1} |> update_elem(0, fn _ -> 2 end)
  end
end
