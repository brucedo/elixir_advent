defmodule AdventDay6 do

  def run() do
    bytestream = Common.open(File.cwd, "day6.txt") |> Common.read_file_pipe() |> Common.close() |> List.first()

    start_of_packet = find_start_of_packet(bytestream)
    start_of_message = find_start_of_message(bytestream)

    IO.puts("Start of packet is: " <> Integer.to_string(start_of_packet))
    IO.puts("Start of message is: " <> Integer.to_string(start_of_message))
  end

  @spec value_of(String.t()) :: integer()
  def value_of(character) do
    <<ascii::utf8>> = character
    cond do
      ascii < 96 ->
        ascii - 39
      true ->
        ascii - 97
    end
  end

  @spec bucket_adder(tuple(), integer()) :: {tuple(), boolean()}
  def bucket_adder(bucket, index) do
    count_at_index = elem(bucket, index)
    updated = put_elem(bucket, index, count_at_index + 1)
    {updated, elem(updated, index) == 2}
  end

  @spec bucket_subtracter(tuple(), integer()) :: {tuple(), boolean()}
  def bucket_subtracter(bucket, index) do
    IO.puts("index: " <> Integer.to_string(index))
    IO.puts("value at index: " <> Integer.to_string(elem(bucket, index)))
    updated = put_elem(bucket, index, elem(bucket, index) - 1)
    {updated, elem(updated, index) == 1}
  end

  @spec find_start_of_message(String.t()) :: integer()
  def find_start_of_message(bytestream) do
    bucket = Tuple.duplicate(0, 26)
    window = []

    {window, bucket, dupe_counter} = initialize_som(0, window, bucket, 0, bytestream)

    process_bytestream(window, 14, bucket, dupe_counter, 14, bytestream)
  end

  @spec find_start_of_packet(String.t()) :: integer()
  def find_start_of_packet(bytestream) do
    bucket = Tuple.duplicate(0, 26)
    window = []

    {window, bucket, dupe_counter} = initialize(0, window, bucket, 0, bytestream)

    start_of_packet = process_bytestream(window, 4, bucket, dupe_counter, 4, bytestream)

    start_of_packet
  end

  @spec process_bytestream(list(integer()), integer(), tuple(), integer(), integer(), String.t()) :: integer()

  defp process_bytestream(_window, _window_size, _bucket, 0, index, _byte_stream) do
    index
  end

  defp process_bytestream(window, window_size, bucket, dupe_counter, index, byte_stream) do

    {outgoing, window} = List.pop_at(window, window_size - 1)

    {bucket, duplicate_indicator} = bucket_subtracter(bucket, outgoing)
    dupe_counter = if duplicate_indicator do dupe_counter - 1 else dupe_counter end

    incoming = String.at(byte_stream, index) |> value_of()
    {bucket, duplicate_indicator} = bucket_adder(bucket, incoming)
    dupe_counter = if duplicate_indicator do dupe_counter + 1 else dupe_counter end
    window = List.insert_at(window, 0, incoming)

    process_bytestream(window, window_size, bucket, dupe_counter, index + 1, byte_stream)
  end

  @spec initialize(integer(), list(integer()), tuple(), integer(), String.t()) :: {list(integer()), tuple(), integer()}
  defp initialize(4, window, bucket, dupe_counter, _) do
    {window, bucket, dupe_counter}
  end

  defp initialize(counter, window, bucket, dupe_counter, bytestream) do
    current_index = String.at(bytestream, counter) |> value_of()
    {bucket, duplicate} = bucket_adder(bucket, current_index)
    dupe_counter = if duplicate do dupe_counter + 1 else dupe_counter end
    window = List.insert_at(window, 0, current_index)

    initialize(counter + 1, window, bucket, dupe_counter, bytestream)
  end

  @spec initialize_som(integer(), list(integer()), tuple(), integer(), String.t()) :: {list(integer()), tuple(), integer()}
  defp initialize_som(14, window, bucket, dupe_counter, _) do
    {window, bucket, dupe_counter}
  end

  defp initialize_som(counter, window, bucket, dupe_counter, bytestream) do
    current_index = String.at(bytestream, counter) |> value_of()
    {bucket, duplicate} = bucket_adder(bucket, current_index)
    dupe_counter = if duplicate do dupe_counter + 1 else dupe_counter end
    window = List.insert_at(window, 0, current_index)

    initialize_som(counter + 1, window, bucket, dupe_counter, bytestream)
  end

end
