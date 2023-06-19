defmodule Advent2022day5 do

  def separate_input([]) do
    []
  end

  @spec separate_input(list(String.t())) :: {list(), list()}
  def separate_input(input) do
    separator = min(Enum.find_index(input, fn element -> element == "" end), length(input))
    start_state = Enum.slice(input, 0, separator)
    move_list = Enum.slice(input, separator + 1, length(input))

    {start_state, move_list}
  end

  @spec construct_stacks(list(String.t())) :: {any()}
  def construct_stacks([]) do
    {}
  end

  def construct_stacks(start_state) do

    inverted_state = Enum.reverse(start_state)
    {index_row, stack_state} = List.pop_at(inverted_state, 0)
    stack_count = stack_count(index_row)
    stacks = List.duplicate([:empty], stack_count)

    load_stacks(stack_state, stacks) |> List.to_tuple()
    # Tuple.duplicate([:empty], stack_count)

  end

  @spec load_stacks(list(String.t()), list()) :: list()
  defp load_stacks([], stacks) do
    stacks
  end

  defp load_stacks(stack_state, stacks) do

    {crates_to_load, remaining} = List.pop_at(stack_state, 0)
    IO.puts("crates to load: " <> crates_to_load <> ", remaining: " <> List.to_string(remaining))
    stacks = load_crates(crates_to_load, stacks)
    load_stacks(remaining, stacks)

  end

  @spec load_crates(String.t(), list(list(String.t()))) :: list()
  defp load_crates(stack_row, stacks)
    when stack_row == ""
    when stacks == []
  do
    stacks
  end

  defp load_crates(stack_row, [first | rest]) do
    IO.puts("New call to load_crates")
    IO.puts(stack_row)
    {current_column, remaining_columns} = String.split_at(stack_row, 4)
    updated = String.at(current_column, 1) |> String.trim() |> safe_crate_insert(first)
    temp = load_crates(remaining_columns, rest) |> List.insert_at(0, updated)
    IO.puts("Exiting stacker for row " <> stack_row)
    temp
  end

  @spec safe_crate_insert(String.t(), list()) :: list()
  defp safe_crate_insert("", into) do
    into
  end

  defp safe_crate_insert(crate_name, into) do
    List.insert_at(into, 0, crate_name)
  end

  @spec stack_count(String.t()) :: integer()
  defp stack_count(index_row) do
    case String.reverse(index_row) |> String.trim() |> String.split() |> List.first() |> Integer.parse() do
      :error ->
        raise ArgumentError, "Non-numeric value found in srack count row."
      {stack_count, _} -> stack_count
    end
  end

  @spec decode_movements(list(String.t())) :: list({integer(), integer(), integer()})
  def decode_movements(move_list) do
    for movement_str <- move_list, do: tuplize_movement(movement_str)
  end

  @spec tuplize_movement(String.t()) :: {integer(), integer(), integer()}
  defp tuplize_movement(movements) do
    tokens = String.split(movements) |> List.delete_at(0) |> List.delete_at(1) |> List.delete_at(2)
    {count, rest} = List.pop_at(tokens, 0) |> then(fn ({count_str, rest}) -> {Integer.parse(count_str) |> elem(0), rest} end)
    {from, rest} = List.pop_at(rest, 0) |> then(fn ({from_str, rest}) -> {Integer.parse(from_str) |> elem(0), rest} end)
    {to, _} = List.pop_at(rest, 0)  |> then(fn ({to_str, rest}) -> {Integer.parse(to_str) |> elem(0), rest} end)
    # count = Integer.parse(count_str) |> elem(0)
    # from = Integer.parse(from_str) |> elem(0)
    # to = Integer.parse(to_str) |> elem(0)
    {count, from, to}
  end
end
