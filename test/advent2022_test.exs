defmodule Advent2022Test do
  use ExUnit.Case
  doctest Advent2022Day1

  test "greets the world" do
    assert Advent2022Day1.hello() == :world
  end

  test "when handed a list of mixed empty and non-empty strings splitify will produce a sequence of lists where each sequence is composed of all the entries between non-empty entries" do
    assert Advent2022Day1.splitify(["1", "2", "3", "4", "", "5", "6", "7"]) == [
             ["1", "2", "3", "4"],
             ["5", "6", "7"]
           ]
  end

  test "when handed an list of purely empty strings splitify will produce an empty list" do
    assert Advent2022Day1.splitify(["", "", "", "", ""]) == []
  end

  test "when handed an empty list splitify will produce an empty list" do
    assert Advent2022Day1.splitify([]) == []
  end

  test "when given a list of numeric strings to_number will convert them all into integers" do
    assert Advent2022Day1.to_number(["1", "2", "3", "4"]) == [1, 2, 3, 4]
  end

  test "when given an empty list to_number will produce an empty list" do
    assert Advent2022Day1.to_number([]) == []
  end

  test "when handed a list of lists of numbers in string form, inventories_to_number will transform each sublist of strings into a sublist of numbers." do
    assert Advent2022Day1.inventories_to_number([["1", "2", "3", "4"], ["5", "6", "7"]]) == [
             [1, 2, 3, 4],
             [5, 6, 7]
           ]
  end

  test "when handed an empty list, inventories_to_number will simply produce an empty list." do
    assert Advent2022Day1.inventories_to_number([]) == []
  end

  test "sum_inventories reduces a list of sublists to a list of integers, where each integer is the sum of the sublist that occupied its place" do
    assert Advent2022Day1.sum_inventories([[1, 2, 3, 4], [5, 6, 7]]) == [10, 18]
  end

  test "sum_inventories reduces an empty list to an empty list" do
    assert Advent2022Day1.sum_inventories([]) == []
  end
end
