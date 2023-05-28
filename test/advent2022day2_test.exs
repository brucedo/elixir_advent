defmodule Advent2022Day2Test do
  use ExUnit.Case
  doctest Advent2022Day2

  test "Given some list of pairs [A-C, X-Y] then score_choice will generate one score per pair based on your choice" do
    in_list = [{"A", "Y"}, {"B", "X"}, {"C", "Z"}]
    assert Advent2022Day2.score_choices(in_list) == [2, 1, 3]
  end

  test "Given some empty list then score_choice will generate an empty list" do
    in_list = []
    assert Advent2022Day2.score_choices(in_list) == []
  end

  test "Given some list of pairs [A-C, X-Y] then score_play will generate one score per pair based on whether you won or lost" do
    in_list = [{"A", "Y"}, {"B", "X"}, {"C", "Z"}]
    assert Advent2022Day2.score_plays(in_list) == [6, 0, 3]
  end

  test "Given some empty list then score_play will generate an empty list" do
    in_list = []
    assert Advent2022Day2.score_plays(in_list) == []
  end

  test "Given some list of their throw and the desired outcome, then pick_play will return the appropriate play pair to achieve that outcome" do
    in_list = [{"A", "Y"}, {"B", "X"}, {"C", "Z"}]
    assert Advent2022Day2.pick_plays(in_list) == [{"A", "X"}, {"B", "X"}, {"C", "X"}]
  end

end
