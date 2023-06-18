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
  def construct_stacks(start_state) do

    inverted_state = Enum.reverse(start_state)
    {index_row, stack_state} = List.pop_at(inverted_state, 0)
    stack_count = stack_count(index_row)
    Tuple.duplicate([:empty], stack_count)

  end

  @spec load_stacks(list(String.t()), tuple()) :: tuple()
  defp load_stacks(src, dst) do

    {crates_to_load, remaining} = List.pop_at(inverted_stack_state, 0)

  end

  @spec load_crates(String.t(), tuple())

  @spec stack_count(String.t()) :: integer()
  defp stack_count(index_row) do
    case String.reverse(index_row) |> String.trim() |> String.split() |> List.first() |> Integer.parse() do
      :error ->
        raise ArgumentError, "Non-numeric value found in srack count row."
      {stack_count, _} -> stack_count
    end
  end

  def decode_movements(move_list) do

  end
end
