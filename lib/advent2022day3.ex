defmodule Advent2022day3 do
  def run do
    lines = File.cwd() |> Common.open("day3.txt") |> Common.read_file()
    split_lines = for line <- lines, do: halve(line)
    dupes = for pair <- split_lines, do: find_duplicate(List.first(pair), List.last(pair))
    priorities = find_priority(dupes)
    total = Enum.reduce(priorities, 0, fn priority, acc -> acc + priority end)
    IO.puts("The total priority for all misplaced items is " <> Integer.to_string(total))

    triples = triplify(lines)

    badges =
      for triple <- triples,
          do: find_triplicate(Enum.at(triple, 0), Enum.at(triple, 1), Enum.at(triple, 2))

    triple_priorities = find_priority(badges)
    badge_total = Enum.reduce(triple_priorities, 0, fn priority, acc -> acc + priority end)
    IO.puts("The priority of badges is " <> Integer.to_string(badge_total))
  end

  def halve(line) do
    midpoint = String.length(line) |> div(2)
    String.split_at(line, midpoint) |> Tuple.to_list()
  end

  def find_duplicate(left, right) do
    dupe_store = MapSet.new(String.graphemes(left))
    Enum.find(String.graphemes(right), fn char -> MapSet.member?(dupe_store, char) end)
  end

  def triplify(lines) do
    Enum.chunk_every(lines, 3)
  end

  def find_triplicate(first, second, third) do
    first_set = MapSet.new(String.graphemes(first))
    second_set = MapSet.new(String.graphemes(second))

    Enum.find(String.graphemes(third), fn char ->
      MapSet.member?(first_set, char) && MapSet.member?(second_set, char)
    end)
  end

  def find_priority(to_score) do
    for item <- to_score, do: match_priority(item)
  end

  defp match_priority(nil) do
    0
  end

  defp match_priority(item) do
    <<ascii::utf8>> = item

    cond do
      ascii < 96 ->
        ascii - 38

      true ->
        ascii - 96
    end
  end
end
