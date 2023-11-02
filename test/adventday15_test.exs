defmodule Adventday15Test do
  use ExUnit.Case
  require ExUnit.Assertions
  doctest AdventDay15

  test "Given some text sequence that represents a sensor and linked beacon pair, sense_pair will generate a tuple {:ok, {sensor_point, beacon_point}}" do
    line = "Sensor at x=2, y=18: closest beacon is at x=-2, y=15"

    {success, sensor_coord, beacon_coord} = AdventDay15.sense_pair(line)

    assert success == :ok
    assert sensor_coord == %Point{x: 2, y: 18}
    assert beacon_coord == %Point{x: -2, y: 15}
  end

  test "Given some text sequence that does not match the format of the sensor line, sense_pair will generate an {:error, msg} tuple" do
    line = "Not at all the right format: but there's some parts of it x=6 that match"

    {success, msg} = AdventDay15.sense_pair(line)

    assert success == :error
  end

  test "Given some text sequence whose format is correct but whose numeric values are non-numeric, sense_pair will generate an {:error, msg} tuple" do
    line = "Sensor at x=pizza, y=ham: closest beacon is at x=-none, y=left_beef"

    {success, msg} = AdventDay15.sense_pair(line)

    assert success == :error
  end

  test "Given some list of points, field_dim will return a tuple {upper_left, lower_right} indicating the upper left and lower right coordinates of the map" do
    points = [%Point{x: 22, y: 5}, %Point{x: 1515, y: 2213}, %Point{x: -124242, y: 24241}, %Point{x: 4, y: -55443322}]

    {upper_left, lower_right} = AdventDay15.field_dim(points)

    assert %Point{x: -124242, y: -55443322} == upper_left
    assert %Point{x: 1515, y: 24241} == lower_right
  end



end
