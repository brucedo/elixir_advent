defmodule Advent2022Day1 do
  @moduledoc """
  Documentation for `Advent2022Day1`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Advent2022Day1.hello()
      :world

  """

  # Calorie counting elves.  Read in a file where each line is either a blank or a number.
  # Each collection of lines bordered by blanks is one elfs inventory. Find the elf who has
  # largest calorie count in their inventory.

  # Transformation steps:
  # - Read file data into a list.
  # - Break list of entries up by elf.
  # - Sum each elfs inventories up
  # - Find the max.

  # Not too hard.  If there is an unflatten function that will let me collect list entries
  # by criteria, then we can go from [123, 456, 789, :none, 1023] to [[123, 456, 789], [1023]].
  # otherwise we'll need some intermediate representation.

  # There is not.  We could instead do something like:
  # def collect([head | tail]) when head == "" do
  # and
  # def collect([head | tail]) when head != "" do

  def hello do
    :world
  end

  def run do
    calory_counts =
      File.cwd()
      |> open()
      |> read_file()
      |> splitify()
      |> inventories_to_number()
      |> sum_inventories()

    largest_calory = Enum.max(calory_counts)

    top_three =
      Enum.sort(calory_counts, fn l, r -> l >= r end)
      |> Enum.slice(0..2)
      |> List.foldl(0, fn e, a -> a + e end)

    IO.puts("Biggest caloric contributor: " <> Integer.to_string(largest_calory))
    IO.puts("Top three total: " <> Integer.to_string(top_three))
    :ok
  end

  def splitify(calory_counts) do
    Enum.chunk_by(calory_counts, fn e -> e == "" end)
    |> Enum.reject(fn [head | _tail] -> head == "" end)
  end

  def to_number(calory_counts) do
    for calory <- calory_counts, do: Integer.parse(calory, 10) |> elem(0)
  end

  def inventories_to_number(inventories) do
    for caloric_inventory <- inventories, do: to_number(caloric_inventory)
  end

  def sum_inventories(inventories) do
    for inventory <- inventories, do: List.foldl(inventory, 0, fn e, a -> a + e end)
  end

  def open({:error, _msg}) do
    raise File.Error, message: "Could not open file."
  end

  def open({:ok, working_dir}) do
    Path.join(working_dir, "day1.txt") |> File.open([:read, :utf8])
  end

  def read_file({:error, _msg}) do
    raise IO.StreamError, message: "Input stream could not be created."
  end

  def read_file({:ok, stream}) do
    IO.stream(stream, :line) |> Enum.map(fn cal -> String.trim(cal) end)
  end
end
