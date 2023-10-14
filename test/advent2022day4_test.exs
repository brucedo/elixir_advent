defmodule Advent2022day4Test do
  use ExUnit.Case
  doctest Advent2022day4

  test "starts_later must return the list whose first number is the least" do
    left = [2, 3, 4, 5, 6, 7, 8]
    right = [3, 4, 5, 6, 7]
    starts_later = Advent2022day4.starts_later(left, right)

    assert starts_later == right
  end

  test "starts_later must return the shorter of two lists if both sides start with the same number" do
    left = [2, 3, 4, 5, 6]
    right = [2, 3, 4, 5]

    starts_later = Advent2022day4.starts_later(left, right)

    assert starts_later == right
  end

  test "starts_later must return the non-empty list if one of the two lists is empty" do
    left = []
    right = [2, 3, 4, 5]
    starts_later = Advent2022day4.starts_later(left, right)

    assert starts_later == left
  end

  test "starts_later will return an empty list if both of the lists are empty" do
    left = []
    right = []

    starts_later = Advent2022day4.starts_later(left, right)

    assert starts_later == left && starts_later == right
  end

  test "ends_sooner will return the list whose last value is the smallest" do
    left = [2, 3, 4, 5, 6, 7, 8]
    right = [3, 4, 5, 6, 7]

    ends_sooner = Advent2022day4.ends_sooner(left, right)

    assert ends_sooner == right
  end

  test "ends_sooner will return the list which is shortest if both last values are identical" do
    left = [2, 3, 4, 5, 6, 7]
    right = [1, 2, 3, 4, 5, 6, 7]

    ends_sooner = Advent2022day4.ends_sooner(left, right)

    assert ends_sooner == left
  end

  test "ends_sooner will return the non-empty list if one of the two inputs is non-empty" do
    left = []
    right = [1, 2, 3, 4, 5]

    ends_sooner = Advent2022day4.ends_sooner(left, right)

    assert ends_sooner == right
  end

  test "ends_sooner will return an empty list if both inputs are empty" do
    left = []
    right = []
    ends_sooner = Advent2022day4.ends_sooner(left, right)

    assert ends_sooner == left && ends_sooner == right
  end

  test "when given text sequence with two numeric ranges in the format of ###-###,###-### then convert_assignments will two lists consisting of numbers between the input ranges" do
    assignments = "2-8,3-7"

    assignment_ranges = Advent2022day4.convert_assignments(assignments)

    left = elem(assignment_ranges, 0)
    right = elem(assignment_ranges, 1)

    assert left == [2, 3, 4, 5, 6, 7, 8]
    assert right == [3, 4, 5, 6, 7]
  end
end
