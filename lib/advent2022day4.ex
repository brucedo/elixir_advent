defmodule Advent2022day4 do
  def run() do
    assignment_list =
      Common.open(File.cwd(), "day4.txt") |> Common.read_file_pipe() |> Common.close()

    assignment_ranges = Enum.map(assignment_list, &convert_assignments/1)

    proper_subsets =
      for {left_range, right_range} <- assignment_ranges,
          do: starts_later(left_range, right_range) == ends_sooner(left_range, right_range)

    overlap_count =
      Enum.filter(proper_subsets, fn element -> element == true end)
      |> Enum.count()
      |> Integer.to_string()

    IO.puts("There are " <> overlap_count <> " proper subsets.")

    any_overlaps =
      for {left_range, right_range} <- assignment_ranges, do: any_overlap(left_range, right_range)

    any_overlap_count =
      Enum.filter(any_overlaps, fn element -> element end) |> Enum.count() |> Integer.to_string()

    IO.puts(
      "There are " <> any_overlap_count <> " total pairs with any overlap at all between them."
    )
  end

  def any_overlap(left, right) do
    right_start = List.first(right)
    right_end = List.last(right)
    left_start = List.first(left)
    left_end = List.last(left)

    (left_start >= right_start && left_start <= right_end) ||
      (right_start >= left_start && right_start <= left_end)
  end

  def starts_later([], []) do
    []
  end

  def starts_later(left, right) when left == [] or right == [] do
    []
  end

  def starts_later(left, right) do
    left_first = List.first(left)
    right_first = List.first(right)

    cond do
      left_first > right_first ->
        left

      left_first < right_first ->
        right

      left_first == right_first ->
        cond do
          length(left) > length(right) -> right
          length(left) < length(right) -> left
          true -> left
        end
    end
  end

  def ends_sooner([], []) do
    []
  end

  def ends_sooner([], right) do
    right
  end

  def ends_sooner(left, []) do
    left
  end

  def ends_sooner(left, right) do
    left_last = List.last(left)
    right_last = List.last(right)

    cond do
      left_last > right_last ->
        right

      left_last < right_last ->
        left

      left_last == right_last ->
        cond do
          length(left) > length(right) -> right
          true -> left
        end
    end
  end

  def convert_assignments(assignment_string) do
    [left_range, right_range] = String.split(assignment_string, ",", parts: 2)
    [left_start, left_end] = txt_range_to_integer(left_range)
    [right_start, right_end] = txt_range_to_integer(right_range)

    left_assignments = rangeToNumbers(left_start, left_end)
    right_assignments = rangeToNumbers(right_start, right_end)

    {left_assignments, right_assignments}
  end

  defp txt_range_to_integer(txt_range) do
    [start_txt, end_txt] = String.split(txt_range, "-", parts: 2)
    start_num = Integer.parse(start_txt) |> to_integer()
    end_num = Integer.parse(end_txt) |> to_integer()

    [start_num, end_num]
  end

  defp to_integer(:error) do
    raise("Non-parseable value in place of integer")
  end

  defp to_integer({value, _}) do
    value
  end

  defp rangeToNumbers(start, stop) when start < stop do
    List.insert_at(rangeToNumbers(start + 1, stop), 0, start)
  end

  defp rangeToNumbers(start, stop) when start == stop do
    [stop]
  end

  defp rangeToNumbers(start, stop) when start > stop do
    raise("Start should never be bigger than stop.")
  end
end
