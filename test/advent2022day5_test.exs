defmodule Advent2022day5Test do
  use ExUnit.Case
  doctest Advent2022day4

  test "separate_input will turn well farmatted input into a two element tuple of the stack start state and the move list" do
    input = ["    [D]", "[N] [C]", "[Z] [M] [P]", " 1   2   3 ", "", "move 1 from 2 to 1", "move 3 from 1 to 3", "move 2 from 2 to 1", "move 1 from 1 to 2"]

    {start_state, move_list} = Advent2022day5.separate_input(input)
    assert start_state == ["    [D]", "[N] [C]", "[Z] [M] [P]", " 1   2   3 "]
    assert move_list == ["move 1 from 2 to 1", "move 3 from 1 to 3", "move 2 from 2 to 1", "move 1 from 1 to 2"]
  end

  test "separate_input will return an empty tuple if the input is empty" do
    input = []

    assert Advent2022day5.separate_input(input) == []
  end

  test "separate_input uses the first empty string as the section separator" do
    input = ["[D]", "", "", "move 1 from 2 to 1"]

    {start_state, move_list} = Advent2022day5.separate_input(input)
    assert start_state = ["[D]"]
    assert move_list = ["", "move 1 from 2 to 1"]
  end

  test "separate_input will never return a tuple whose arity > 2 no matter how many section separators are included in the input" do
    input = ["    [D]", "[N] [C]", "[Z] [M] [P]", " 1   2   3 ", "", "", "", "", "move 1 from 2 to 1", "move 3 from 1 to 3", "", "move 2 from 2 to 1", "move 1 from 1 to 2"]

    {start_state, move_list} = Advent2022day5.separate_input(input)
    assert start_state == ["    [D]", "[N] [C]", "[Z] [M] [P]", " 1   2   3 "]
    assert move_list == ["", "", "", "move 1 from 2 to 1", "move 3 from 1 to 3", "", "move 2 from 2 to 1", "move 1 from 1 to 2"]
  end

  test "separate_input will produce an empty list for the move_list if there is no separator" do
    input = ["[D]"]

    {start_state, move_list} = Advent2022day5.separate_input(input)
    assert start_state = ["[D]"]
    assert move_list = []
  end

  test "separate_input will produce an empty list for the move list if there are no elements after the separator" do
    input = ["[D]", ""]

    {start_state, move_list} = Advent2022day5.separate_input(input)
    assert start_state = ["[D]"]
    assert move_list = []
  end

  test "separate_input will produce an empty list for the start state if there are no elements before the separator" do
    input = ["", "move 1 from 2 to 1"]

    {start_state, move_list} = Advent2022day5.separate_input(input)
    assert start_state = []
    assert move_list = ["move 1 from 2 to 1"]
  end

  @tag :failing
  test "construct_stacks will generate a tuple of stacks from the start state section where the topmost crate is the last item inserted for each stack" do
    input = ["    [D]", "[N] [C]", "[Z] [M] [P]", " 1   2   3 "]

    crate_stacks = Advent2022day5.construct_stacks(input)

    assert tuple_size(crate_stacks) == 3

    assert elem(crate_stacks, 0) == ["N", "Z", :empty]
    assert elem(crate_stacks, 1) == ["D", "C", "M", :empty]
    assert elem(crate_stacks, 2) == ["P", :empty]
  end

  test "construct_stacks will generate an empty tuple if the start_state input is empty" do
    input = []

    crate_stacks = Advent2022day5.construct_stacks(input)

    assert tuple_size(crate_stacks) == 0
  end

  test "decode_movements will convert the move_list into a list of tuples {move_count, src_stack, dest_stack} in the order they are listed" do
    input = ["move 1 from 2 to 1", "move 2 from 3 to 1"]

    movements = Advent2022day5.decode_movements(input)

    assert movements == [{1, 2, 1}, {2, 3, 1}]
  end

end
