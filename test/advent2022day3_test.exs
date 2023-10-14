defmodule Advent2022day3Test do
  use ExUnit.Case
  doctest Advent2022day3

  test "given some single string, halve/1 will split the string into two parts and return each half as an element in a list" do
    to_split = "abcdefghijklmnopqrstuvwxyz"
    assert Advent2022day3.halve(to_split) == ["abcdefghijklm", "nopqrstuvwxyz"]
  end

  test "given some empty string, halve/1 will return a pair of empty strings in a list" do
    assert Advent2022day3.halve("") == ["", ""]
  end

  test "given some pair of strings find_duplicate/2 will identify and return as a scalar the letter that is found in both pairs" do
    left = "avdsdJkKhLkJMnhLljK"
    right = "opqPQOWZxK"
    assert Advent2022day3.find_duplicate(left, right) == "K"
  end

  test "given some pair of empty strings find_duplicate/2 will return nil" do
    left = ""
    right = ""
    assert Advent2022day3.find_duplicate(left, right) == nil
  end

  test "given some pair of strings with no common letter find_duplicate will return nil" do
    left = "a"
    right = "b"
    assert Advent2022day3.find_duplicate(left, right) == nil
  end

  test "give some list of characters find_priority/1 will convert every character to a number representing its appropriate priority" do
    to_score = ["a", "b", "C", "Z"]
    assert Advent2022day3.find_priority(to_score) == [1, 2, 29, 52]
  end

  test "given a nil in a list of characters find_priority/1 will replace nil with 0" do
    to_score = ["c", "A", nil, "Z"]
    assert Advent2022day3.find_priority(to_score) == [3, 27, 0, 52]
  end

  test "given some triple of strings, find_triplicate will find and return a letter if it is used in all three triples" do
    first = "abcdefg"
    second = "ghijklmn"
    third = "opqrstufg"
    assert Advent2022day3.find_triplicate(first, second, third) == "g"
  end

  test "given some triple of empty strings, find_triplicate will return nil" do
    first = ""
    second = ""
    third = ""
    assert Advent2022day3.find_triplicate(first, second, third) == nil
  end

  test "given some triple of strings with no letter in common across all three, find_triplicate will return nil" do
    first = "abcdefg"
    second = "ghijklm"
    third = "opqrstuv"
    assert Advent2022day3.find_triplicate(first, second, third) == nil
  end

  test "Given some input list of strings, triplify()/1 will return a list of lists, where each nested list is three sequential strings from the input" do
    input = ["asdf", "jklm", "zxcv", "qwert", "yuio", "sdfgh"]

    assert Advent2022day3.triplify(input) == [
             ["asdf", "jklm", "zxcv"],
             ["qwert", "yuio", "sdfgh"]
           ]
  end
end
