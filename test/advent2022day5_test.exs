defmodule Advent2022day5Test do
  use ExUnit.Case
  doctest Advent2022day4

  test "separate_input will turn well farmatted input into a two element tuple of the stack start state and the move list" do
    input = [
      "    [D]",
      "[N] [C]",
      "[Z] [M] [P]",
      " 1   2   3 ",
      "",
      "move 1 from 2 to 1",
      "move 3 from 1 to 3",
      "move 2 from 2 to 1",
      "move 1 from 1 to 2"
    ]

    {start_state, move_list} = Advent2022day5.separate_input(input)
    assert start_state == ["    [D]", "[N] [C]", "[Z] [M] [P]", " 1   2   3 "]

    assert move_list == [
             "move 1 from 2 to 1",
             "move 3 from 1 to 3",
             "move 2 from 2 to 1",
             "move 1 from 1 to 2"
           ]
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
    input = [
      "    [D]",
      "[N] [C]",
      "[Z] [M] [P]",
      " 1   2   3 ",
      "",
      "",
      "",
      "",
      "move 1 from 2 to 1",
      "move 3 from 1 to 3",
      "",
      "move 2 from 2 to 1",
      "move 1 from 1 to 2"
    ]

    {start_state, move_list} = Advent2022day5.separate_input(input)
    assert start_state == ["    [D]", "[N] [C]", "[Z] [M] [P]", " 1   2   3 "]

    assert move_list == [
             "",
             "",
             "",
             "move 1 from 2 to 1",
             "move 3 from 1 to 3",
             "",
             "move 2 from 2 to 1",
             "move 1 from 1 to 2"
           ]
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

  test "given some movement, move_crates will move the correct number of crates to the correct location, from the correct starting point" do
    stacks = {["N", "Z", :empty], ["D", "C", "M", :empty], ["P", :empty]}
    movement = {1, 2, 1}

    assert Advent2022day5.move_crates(stacks, movement) ==
             {["D", "N", "Z", :empty], ["C", "M", :empty], ["P", :empty]}
  end

  test "given some list of movements, perform_movements will process each list of movements in order from first to last" do
    stacks = {["N", "Z", :empty], ["D", "C", "M", :empty], ["P", :empty]}
    movement = [{1, 2, 1}, {3, 1, 3}, {2, 2, 1}, {1, 1, 2}]

    stacks = Advent2022day5.perform_movements(stacks, movement)

    assert stacks == {["C", :empty], ["M", :empty], ["Z", "N", "D", "P", :empty]}
  end

  test "given some list of movements, perform_9001_movements will move the number of crates from the source stack to the destination while keeping the order" do
    stacks = {["N", "Z", :empty], ["D", "C", "M", :empty], ["P", :empty]}
    movement = [{1, 2, 1}, {3, 1, 3}, {2, 2, 1}, {1, 1, 2}]

    stacks = Advent2022day5.perform_9001_movements(stacks, movement)

    assert stacks == {["M", :empty], ["C", :empty], ["D", "N", "Z", "P", :empty]}
  end

  test "given some movement, move_crates_9001 will move all of the crates from the source to the destination and keep the original order" do
    stacks = {["D", "N", "Z", :empty], ["C", "M", :empty], ["P", :empty]}
    movement = {3, 1, 3}

    assert Advent2022day5.move_crates_9001(stacks, movement) ==
             {[:empty], ["C", "M", :empty], ["D", "N", "Z", "P", :empty]}
  end
end
