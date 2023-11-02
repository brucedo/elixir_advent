defmodule Adventday8Test do
  use ExUnit.Case
  require ExUnit.Assertions
  doctest AdventDay7


  test "when provided an empty list, construct_tree_grid will return a map with no Tree entries and width & height property of 0." do
    input = []

    tree_grid = AdventDay8.construct_tree_grid(input)

    assert tree_grid.width == 0
    assert tree_grid.height == 0
    assert map_size(tree_grid) == 2
  end

  test "when provided a list of empty lists, construct_tree_grid will return a map with no Tree entries and width & height property of 0." do
    input = [[], [], [], [], []]

    tree_grid = AdventDay8.construct_tree_grid(input)
    assert tree_grid.width == 0
    assert tree_grid.height == 0
    assert map_size(tree_grid) == 2
  end

  test "when provided a non-empty list of size m comprised of non-empty lists of size n, construct_tree_grid will return a map where width is n,
  height is m and nxm Trees" do
    input = [[3,0,3,7,3], [2,5,5,1,2]]

    tree_grid = AdventDay8.construct_tree_grid(input)

    assert tree_grid.width == 4
    assert tree_grid.height == 1
    assert map_size(tree_grid) == 12
  end

  test "when provided with a list of size m comprised of at least one non-empty list and at least one empty list, construct_tree_grid will return a map whose
  width is n and whose height is the total number of non-empty nested lists" do
    input = [[3,0,3,7,3], [], [2,5,5,1,2]]

    tree_grid = AdventDay8.construct_tree_grid(input)

    assert tree_grid.width == 4
    assert tree_grid.height == 1
    assert map_size(tree_grid) == 12
  end

  test "when a tree grid of size 1 is passed into calculate_maxima, then the east, west, north and south maxima will be set to -1" do
    tree_grid = %{%Point{x: 0, y: 0} => 5, width: 1, height: 1}

    maxima_grid = AdventDay8.calculate_maxima(tree_grid)

    sole_tree = Map.get(maxima_grid, %Point{x: 0, y: 0})
    assert sole_tree.east_max == -1
    assert sole_tree.west_max == -1
    assert sole_tree.north_max == -1
    assert sole_tree.south_max == -1

  end

  test "when a tree grid with only one row is passed into the calculate_maxima, then all north and south maxima will be -1" do
    tree_grid = %{%Point{x: 0, y: 0} => 5,
      %Point{x: 0, y: 0} => 3,
      %Point{x: 1, y: 0} => 7,
      %Point{x: 2, y: 0} => 3,
      %Point{x: 3, y: 0} => 9,
      width: 3,
      height: 0
    }

    maxima_grid = AdventDay8.calculate_maxima(tree_grid)

    assert Enum.reject(maxima_grid, fn pair -> elem(pair, 0) == :width || elem(pair, 0) == :height end) |>
      Enum.map(fn kv -> elem(kv, 1) end) |>
      Enum.all?(fn tree -> tree.north_max == -1 && tree.south_max == -1 end)
  end

  test "when a tree grid with only one column is passed into calculate_maxima, then all east and west maximal will be -1" do
    tree_grid = %{
      %Point{x: 0, y: 0} => 4,
      %Point{x: 0, y: 1} => 6,
      %Point{x: 0, y: 2} => 7,
      %Point{x: 0, y: 3} => 4,
      %Point{x: 0, y: 4} => 3,
      width: 0,
      height: 4
    }

    maxima_grid = AdventDay8.calculate_maxima(tree_grid)

    assert Enum.filter(maxima_grid, fn kv -> elem(kv, 0) != :width && elem(kv, 0) != :height end) |>
      Enum.map(fn kv -> elem(kv, 1) end) |>
      Enum.all?(fn tree -> tree.east_max == -1 && tree.west_max == -1 end)
  end

  test "each element of a tree grid's row will have an west max that is the tallest tree to the left" do
    tree_grid = %{
      %Point{x: 0, y: 0} => 3,
      %Point{x: 1, y: 0} => 5,
      %Point{x: 2, y: 0} => 4,
      %Point{x: 3, y: 0} => 5,
      %Point{x: 4, y: 0} => 6,
      width: 4,
      height: 0
    }

    maxima_grid = AdventDay8.calculate_maxima(tree_grid)

    assert Map.get(maxima_grid, %Point{x: 0, y: 0}) |> Map.get(:west_max) == -1
    assert Map.get(maxima_grid, %Point{x: 1, y: 0}) |> Map.get(:west_max) == 3
    assert Map.get(maxima_grid, %Point{x: 2, y: 0}) |> Map.get(:west_max) == 5
    assert Map.get(maxima_grid, %Point{x: 3, y: 0}) |> Map.get(:west_max) == 5
    assert Map.get(maxima_grid, %Point{x: 4, y: 0}) |> Map.get(:west_max) == 5
  end

  test "each element of a tree grid's row will have a east max that is the tallest tree to the right" do
    tree_grid = %{
      %Point{x: 0, y: 0} => 3,
      %Point{x: 1, y: 0} => 5,
      %Point{x: 2, y: 0} => 4,
      %Point{x: 3, y: 0} => 5,
      %Point{x: 4, y: 0} => 6,
      width: 4,
      height: 0
    }

    maxima_grid = AdventDay8.calculate_maxima(tree_grid)

    assert Map.get(maxima_grid, %Point{x: 0, y: 0}) |> Map.get(:east_max) == 6
    assert Map.get(maxima_grid, %Point{x: 1, y: 0}) |> Map.get(:east_max) == 6
    assert Map.get(maxima_grid, %Point{x: 2, y: 0}) |> Map.get(:east_max) == 6
    assert Map.get(maxima_grid, %Point{x: 3, y: 0}) |> Map.get(:east_max) == 6
    assert Map.get(maxima_grid, %Point{x: 4, y: 0}) |> Map.get(:east_max) == -1
  end

  test "each element of a tree grid's column will have a north_max that is the tallest tree above it in the column" do
    tree_grid = %{
      %Point{x: 0, y: 0} => 3,
      %Point{x: 0, y: 1} => 5,
      %Point{x: 0, y: 2} => 4,
      %Point{x: 0, y: 3} => 5,
      %Point{x: 0, y: 4} => 6,
      width: 0,
      height: 4
    }

    maxima_grid = AdventDay8.calculate_maxima(tree_grid)

    assert Map.get(maxima_grid, %Point{x: 0, y: 0}) |> Map.get(:north_max) == -1
    assert Map.get(maxima_grid, %Point{x: 0, y: 1}) |> Map.get(:north_max) == 3
    assert Map.get(maxima_grid, %Point{x: 0, y: 2}) |> Map.get(:north_max) == 5
    assert Map.get(maxima_grid, %Point{x: 0, y: 3}) |> Map.get(:north_max) == 5
    assert Map.get(maxima_grid, %Point{x: 0, y: 4}) |> Map.get(:north_max) == 5
  end

  test "each element of a tree grid's column will have a south max that is the tallest tree below it in the column" do
    tree_grid = %{
      %Point{x: 0, y: 0} => 2,
      %Point{x: 0, y: 1} => 3,
      %Point{x: 0, y: 2} => 6,
      %Point{x: 0, y: 3} => 4,
      %Point{x: 0, y: 4} => 3,
      width: 0,
      height: 4
    }

      maxima_grid = AdventDay8.calculate_maxima(tree_grid)

      assert Map.get(maxima_grid, %Point{x: 0, y: 0}) |> Map.get(:south_max) == 6
      assert Map.get(maxima_grid, %Point{x: 0, y: 1}) |> Map.get(:south_max) == 6
      assert Map.get(maxima_grid, %Point{x: 0, y: 2}) |> Map.get(:south_max) == 4
      assert Map.get(maxima_grid, %Point{x: 0, y: 3}) |> Map.get(:south_max) == 3
      assert Map.get(maxima_grid, %Point{x: 0, y: 4}) |> Map.get(:south_max) == -1
  end

  test "when given a 1x1 graph where the tree_height is the maxima, find_hidden will produce a 1x1 map whose sole value is false" do
    maxima_grid = %{
      %Point{x: 0, y: 0} => %Tree{west_max: -1, east_max: -1, north_max: -1, south_max: -1, tree_height: 1},
      width: 0,
      height: 0
    }

    hidden_grid = AdventDay8.find_hidden(maxima_grid)

    assert Enum.count(hidden_grid) == 1
    assert Map.has_key?(hidden_grid, %Point{x: 0, y: 0})
    assert !Map.get(hidden_grid, %Point{x: 0, y: 0})
  end

  test "when given a 1x1 graph where the tree height is the minima from all directions, find_hidden will produce a 1x1 map whose sole value is true" do
    maxima_grid = %{
      %Point{x: 0, y: 0} => %Tree{west_max: 4, east_max: 2, north_max: 3, south_max: 1, tree_height: 1},
      width: 0,
      height: 0
    }

    hidden_grid = AdventDay8.find_hidden(maxima_grid)

    assert Enum.count(hidden_grid) == 1
    assert Map.has_key?(hidden_grid, %Point{x: 0, y: 0})
    assert Map.get(hidden_grid, %Point{x: 0, y: 0})
  end

  test "when given a 2x2 graph following the rule that all exposed trees are visible, find_hidden will produce a 2x2 map where all entries are false" do
    maxima_grid = %{
      %Point{x: 0, y: 0} => %Tree{west_max: -1, north_max: -1, east_max: 0, south_max: 2, tree_height: 3},
      %Point{x: 0, y: 1} => %Tree{west_max: 3, north_max: -1, east_max: -1, south_max: 5, tree_height: 0},
      %Point{x: 1, y: 0} => %Tree{west_max: -1, north_max: 3, east_max: 5, south_max: -1, tree_height: 2},
      %Point{x: 1, y: 1} => %Tree{west_max: 2, north_max: 0, east_max: -1, south_max: -1, tree_height: 5},
      width: 1,
      height: 1
    }

    hidden_grid = AdventDay8.find_hidden(maxima_grid)

    assert Map.values(hidden_grid) |> Enum.all?(fn hidden -> !hidden end)
    assert Enum.count(hidden_grid) == 4
  end

  test "when given a 3x3 graph where the local minima is the centremost entity, find_hidden will produce a 3x3 map where the outermost rows & columns are false but the centre point is true" do
    maxima_grid = %{
      %Point{x: 0, y: 0} => %Tree{tree_height: 5, west_max: -1, north_max: -1, east_max: 4, south_max: 7},
      %Point{x: 1, y: 0} => %Tree{tree_height: 4, west_max: 5, north_max: -1, east_max: 3, south_max: 3},
      %Point{x: 2, y: 0} => %Tree{tree_height: 3, west_max: 5, north_max: -1, east_max: -1, south_max: 6},
      %Point{x: 0, y: 1} => %Tree{tree_height: 5, west_max: -1, north_max: 5, east_max: 6, south_max: 7},
      %Point{x: 1, y: 1} => %Tree{tree_height: 1, west_max: 5, north_max: 4, east_max: 6, south_max: 3},
      %Point{x: 2, y: 1} => %Tree{tree_height: 6, west_max: 5, north_max: 3, east_max: -1, south_max: 6},
      %Point{x: 0, y: 2} => %Tree{tree_height: 7, west_max: -1, north_max: 5, east_max: 6, south_max: -1},
      %Point{x: 1, y: 2} => %Tree{tree_height: 3, west_max: 7, north_max: 4, east_max: 6, south_max: -1},
      %Point{x: 2, y: 2} => %Tree{tree_height: 6, west_max: 7, north_max: 6, east_max: -1, south_max: -1},
      width: 2,
      height: 2
    }

    hidden_grid = AdventDay8.find_hidden(maxima_grid)

    assert Map.get(hidden_grid, %Point{x: 1, y: 1})

    Enum.reject(maxima_grid, fn key_value -> elem(key_value, 0) == %Point{x: 1, y: 1} end) |>
      Enum.map(fn key_value -> elem(key_value, 1) end) |>
      Enum.all?(fn hidden -> !hidden end)

  end

  test "given the test set construct_tree_grid, calculate_maxima and hidden_grid in succession will produce a map with 21 visible and 4 hidden trees" do
    trees = [[3,0,3,7,3], [2,5,5,1,2], [6,5,3,3,2], [3,3,5,4,9], [3,5,3,9,0]]

    hidden_grid = AdventDay8.construct_tree_grid(trees) |> AdventDay8.calculate_maxima() |> AdventDay8.find_hidden()

    visible = Map.values(hidden_grid) |> Enum.filter(fn hidden -> !hidden end) |> Enum.count()
    hidden = Map.values(hidden_grid) |> Enum.filter(fn hidden -> hidden end) |> Enum.count()

    assert visible == 21
    assert hidden = 4
  end

end
