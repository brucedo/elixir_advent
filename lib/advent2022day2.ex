defmodule Advent2022Day2 do


def day2() do
  file = Common.open(File.cwd, "day2.txt")
  raw_plays = Common.read_file(file)
  Common.close(file)
  untrimmed_plays = for play <- raw_plays, do: String.split_at(play, 1)
  plays = for {theirs, mine} <- untrimmed_plays, do: {theirs, String.trim(mine)}

  totals = for {choice_score, play_score} <- Enum.zip(score_choices(plays), score_plays(plays)), do: choice_score + play_score
  total = List.foldl(totals, 0, fn e, a -> a + e end)

  IO.puts("Total score for part 1: " <> Integer.to_string(total))

  # part 2
  predicted_plays = pick_plays(plays)
  predicted_totals = for {choice_score, play_score} <- Enum.zip(score_choices(predicted_plays), score_plays(predicted_plays)), do: choice_score + play_score
  predicted_total = List.foldl(predicted_totals, 0, fn e, a -> a + e end)

  IO.puts("Total score from using list as predictions: " <> Integer.to_string(predicted_total))
end

def score_choices(plays) do
  for play <- plays, do: score_choice(play)
end

defp score_choice({_, "X"}) do
  1
end

defp score_choice({_, "Y"}) do
  2
end

defp score_choice({_, "Z"}) do
  3
end

def score_plays(plays) do
  for play <- plays, do: score_play(play)
end

defp score_play({theirs, mine})
  when theirs == "A" and mine == "X"
  when theirs == "B" and mine == "Y"
  when theirs == "C" and mine == "Z"
do
  3
end

defp score_play({theirs, mine})
  when theirs == "A" and mine == "Y"
  when theirs == "B" and mine == "Z"
  when theirs == "C" and mine == "X"
do
  6
end

defp score_play({theirs, mine})
  when theirs == "A" and mine == "Z"
  when theirs == "B" and mine == "X"
  when theirs == "C" and mine == "Y"
do
  0
end

def pick_plays(predicted_list)
do
  for prediction <- predicted_list, do: pick_play(prediction)
end

defp pick_play({theirs, outcome})
  when outcome == "X" and theirs == "B"
  when outcome == "Y" and theirs == "A"
  when outcome == "Z" and theirs == "C"
do
  {theirs, "X"}
end

defp pick_play({theirs, outcome})
  when outcome == "X" and theirs == "C"
  when outcome == "Y" and theirs == "B"
  when outcome == "Z" and theirs == "A"
do
  {theirs, "Y"}
end

defp pick_play({theirs, outcome})
  when outcome == "X" and theirs == "A"
  when outcome == "Y" and theirs == "C"
  when outcome == "Z" and theirs == "B"
do
  {theirs, "Z"}
end

end
