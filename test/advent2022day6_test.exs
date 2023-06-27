defmodule Advent2022Day6Test do
  use ExUnit.Case
  doctest AdventDay6

  test "Given some single-character string, value_of will generate a number unique to that alphabetical character" do
    sample = "q"

    assert 16 == AdventDay6.value_of(sample)
  end

  test "Given the letter 'a' value_of will generate 1" do
    assert 0 == AdventDay6.value_of("a")
  end

  test "Given the letter 'z' value_of_will generate 26" do
    assert 25 == AdventDay6.value_of("z")
  end

  test "Given a tuple-bucket and a numeric index, bucket_adder will increment the value at index in the bucket and return the bucket and true if the new value is == 2" do
    bucket = Tuple.duplicate(0, 26)
    index = 15

    assert AdventDay6.bucket_adder(bucket, index) == {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, false}
  end


  test "Given a tuple-bucket and a numeric index, bucket_adder will increment the value at the index in the bucket and return bucket and false if the new value != 2" do
    bucket = Tuple.duplicate(0, 26) |> put_elem(12, 1)
    index = 12

    assert AdventDay6.bucket_adder(bucket, index) == {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, true}
  end

  test "Given some string, find_start_of_packet returns the number of characters from the start of the sequence to the last letter of the first quadgram with no duplicate characters" do
    bytestream = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"

    assert AdventDay6.find_start_of_packet(bytestream) == 7
  end

  test "Given some string bvwbjplbgvbhsrlpgdmjqwftvncz, find_start_of_packet should return 5" do
    bytestream = "bvwbjplbgvbhsrlpgdmjqwftvncz"

    assert AdventDay6.find_start_of_packet(bytestream) == 5
  end

  test "Given some string nppdvjthqldpwncqszvftbrmjlhg, find_start_of_packet should return 5" do
    bytestream = "nppdvjthqldpwncqszvftbrmjlhg"

    assert AdventDay6.find_start_of_packet(bytestream) == 6
  end

  @tag :failing
  test "Given some string nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg, find_start_of_packet should return 5" do
    bytestream = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"

    assert AdventDay6.find_start_of_packet(bytestream) == 10
  end

  test "Given some string zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw, find_start_of_packet should return 5" do
    bytestream = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"

    assert AdventDay6.find_start_of_packet(bytestream) == 11
  end


end
