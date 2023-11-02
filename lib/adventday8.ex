defmodule Point do

  @typedoc """
  Pair representing a point in 2-space
  """
  @type p :: %__MODULE__{x: integer(), y: integer()}
  defstruct x: -1, y: -1
end

defmodule Tree do
  defstruct east_max: -1, west_max: -1, north_max: -1, south_max: -1, tree_height: -1
end

defmodule AdventDay8 do
require Logger


  def run() do
    tree_input = Common.open(File.cwd, "day8.txt") |> Common.read_file_pipe() |> Common.close()
    tree_heights = Enum.map(tree_input, fn line -> String.codepoints(line) |> Enum.map(fn height_char -> Integer.parse(height_char) |> elem(0) end) end)

    hidden_trees = construct_tree_grid(tree_heights) |> calculate_maxima() |> find_hidden()

    visible = Map.values(hidden_trees) |> Enum.filter(fn hidden -> !hidden end) |> Enum.count()
    hidden = Map.values(hidden_trees) |> Enum.filter(fn hidden -> hidden end) |> Enum.count()

    IO.puts(Integer.to_string(visible) <> " trees are visible.")
    IO.puts(Integer.to_string(hidden) <> " trees are hidden.")
  end


  def construct_tree_grid(trees) do
    build_by_row(trees, 0)
  end

  defp build_by_row([], _) do
    %{width: 0, height: 0}
  end

  defp build_by_row([[] | remaining_rows], row_index ) do
    build_by_row(remaining_rows, row_index)
  end

  defp build_by_row([row | remaining_rows], row_index) do
    map = build_by_row(remaining_rows, row_index + 1)

    width = length(row) - 1
    map = Enum.with_index(row) |> List.foldl(map, fn (next, acc) -> Map.put(acc, %Point{x: elem(next, 1), y: row_index}, elem(next, 0)) end )

    map = if (row_index > map.height) do Map.replace(map, :height, row_index) else map end
    if (width > map.width) do Map.replace(map, :width, width) else map end

  end


  def calculate_maxima(tree_grid) do
    eval_rows(tree_grid, %{width: tree_grid.width, height: tree_grid.height}, %Point{x: 0, y: 0})
  end

  defp eval_rows(tree_grid, height_map, index) do
    if (!Map.has_key?(tree_grid, index)) do
      if Map.has_key?(tree_grid, %Point{x: 0, y: index.y + 1}) do
        eval_rows(tree_grid, height_map,  %Point{x: 0, y: index.y + 1})
      else
        height_map
      end
    else
      north_partial = Map.get(height_map, %Point{x: index.x, y: index.y - 1}, %Tree{})
      north_max = max(north_partial.north_max, Map.get(tree_grid, %Point{x: index.x, y: index.y - 1}, -1))
      west_partial = Map.get(height_map, %Point{x: index.x - 1, y: index.y}, %Tree{})
      west_max = max(west_partial.west_max, Map.get(tree_grid, %Point{x: index.x - 1, y: index.y}, -1))

      Logger.debug("Point (#{index.x}, #{index.y}) has north_max #{north_max}, west_max of #{west_max}")

      partial_tree = %Tree{west_max: west_max, north_max: north_max, tree_height: Map.get(tree_grid, index)}
      height_map = eval_rows(tree_grid, Map.put(height_map, index, partial_tree), %{index | x: index.x + 1})

      east_max = max(Map.get(tree_grid, %{index | x: index.x + 1}, -1), Map.get(height_map, %{index | x: index.x + 1}, %Tree{}) |> Map.get(:east_max))
      south_max = max(Map.get(tree_grid, %{index | y: index.y + 1}, -1), Map.get(height_map, %{index | y: index.y + 1}, %Tree{}) |> Map.get(:south_max))

      Logger.debug("Point (#{index.x}, #{index.y}) has south_max #{south_max}, east_max of #{east_max})")

      full_tree = %{partial_tree | south_max: south_max, east_max: east_max}

      Map.replace(height_map, index, full_tree)

    end
  end

  def find_hidden(maxima_grid) do
    iterate_and_calc_hidden(maxima_grid, %Point{x: 0, y: 0})
  end

  defp iterate_and_calc_hidden(maxima_grid, point) do
    cond do
      point.y > maxima_grid.height ->
        %{}
      point.x > maxima_grid.width ->
        iterate_and_calc_hidden(maxima_grid, %Point{x: 0, y: point.y + 1})
      true ->
        hidden = iterate_and_calc_hidden(maxima_grid, %{point | x: point.x + 1})
        local_maxima = Map.get(maxima_grid, point)
        Map.put(hidden, point, local_maxima.north_max >= local_maxima.tree_height &&
          local_maxima.east_max >= local_maxima.tree_height &&
          local_maxima.west_max >= local_maxima.tree_height &&
          local_maxima.south_max >= local_maxima.tree_height
        )
    end
  end

end
