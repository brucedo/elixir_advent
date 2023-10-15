defmodule AdventDay7 do
  require Logger

  def run() do
    commands = Common.open(File.cwd(), "day7.txt") |> Common.read_file_pipe() |> Common.close()


      directories = process_dir_tree(commands, "");

      all_directory_sizes = directory_sizes("/", directories) |> elem(1)

      IO.inspect(all_directory_sizes)

      sizes_matching_cutoff = all_directory_sizes |> Enum.filter(fn(size) -> size <= 100000 end)
      total_sizes_matching_cutoff = sizes_matching_cutoff |> List.foldl(0, fn(next, total) -> next + total end)
      IO.puts("The total size of all directories under 100k is " <> Integer.to_string(total_sizes_matching_cutoff))

      for size <- all_directory_sizes, do: IO.puts("Directory size: " <> Integer.to_string(size))

      used_space = all_directory_sizes |> List.foldl(0, fn (next, acc) -> if next > acc do next else acc end end)
      IO.puts("Total used space: " <> Integer.to_string(used_space))
      free_space = 70000000 - used_space
      required_space = 30000000 - free_space

      IO.puts("Total free space: " <> Integer.to_string(free_space))
      IO.puts("Space required to free: " <> Integer.to_string(required_space))

      smallest_allowable = all_directory_sizes |> Enum.filter( fn (next) -> next >= required_space end) |> Enum.min()


      IO.puts("The smallest directory size that is at least 30000000 is " <> Integer.to_string(smallest_allowable))
  end

  @spec filter_by_size(%{atom() => String.t(), atom() => list(), atom() => list()}, integer()) :: list(integer())
  def filter_by_size(directories, cutoff) do
    directory_sizes("/", directories) |> elem(1) |> Enum.filter(fn(size) -> size <= cutoff end)

  end

  defp directory_sizes(cwd, directories) do
    current_dir = Map.get(directories, cwd, %{path: cwd, directories: [], files: []})
    file_size = Map.get(current_dir, :files) |> Enum.map( fn file -> Map.get(file, :size, 0) end) |> List.foldl(0, fn (size, total) -> size + total end)
    subdirectories = Map.get(current_dir, :subdirectories)

    subdirectory_sizes = for subdir <- subdirectories, do: directory_sizes(subdir, directories)

    immediate_children_sizes = for subdir <- subdirectory_sizes, do: elem(subdir, 0)
    expanded_subdirs = (for subdir <- subdirectory_sizes, do: elem(subdir, 1)) |> List.flatten()

    total_size = file_size + List.foldl(immediate_children_sizes, 0, fn(size, total) -> size + total end)

    {total_size, [total_size | expanded_subdirs]}

  end

  @spec process_dir_tree(list(String.t()), String.t()) :: %{String.t() => %{atom() => String.t(), atom() => list(), atom() => list()}}

  def process_dir_tree([], _) do
    %{}
  end

  def process_dir_tree(["$ ls" | remaining_cmd], cwd_path) do
    {file_data, subdir_data, remaining_commands} = parse_dir_entries(remaining_cmd)

    files = make_file(file_data)
    subdirectory_paths = for subdir_entry <- subdir_data, do: Path.join(cwd_path, String.split(subdir_entry, " ", parts: 2) |> List.last)

    directory_map = process_dir_tree(remaining_commands, cwd_path)

    current_dir = Map.get(directory_map, cwd_path, %{path: cwd_path, subdirectories: [], files: []})
    current_dir_files = Map.get(current_dir, :files)
    current_dir_subdirs = Map.get(current_dir, :subdirectories)

    current_dir = Map.replace(current_dir, :subdirectories, current_dir_subdirs ++ subdirectory_paths) |>
      Map.replace(:files, current_dir_files ++ files)

    Map.put(directory_map, cwd_path, current_dir)
  end

  def process_dir_tree(["$ cd .." | remaining_cmd], cwd_path) do
    process_dir_tree(remaining_cmd, Path.join(cwd_path, "..") |> Path.expand())
  end

  def process_dir_tree(["$ cd /" | remaining_cmd], _cwd_path) do
    process_dir_tree(remaining_cmd, "/")
  end

  def process_dir_tree([cd_to_dir | remaining_cmd], cwd_path) do
    Logger.debug("Command should be a cd to a specific directory: #{cd_to_dir}")
    new_cwd = Path.join(cwd_path, String.split(cd_to_dir, " ", parts: 3) |> List.last())
    Logger.debug("The new working directory is #{new_cwd}")
    process_dir_tree(remaining_cmd, new_cwd)
  end

  @spec parse_dir_entries(list(String.t())) ::
          {list(String.t()), list(String.t()), list(String.t())}
  def parse_dir_entries([]) do
    Logger.debug(
      "There are no commands left in the command list.  parse_dir_entries is returning all empty lists."
    )

    {[], [], []}
  end

  def parse_dir_entries([next_item | command_io]) do
    Logger.debug(
      "Starting parse_dir_entries with next_item #{next_item} and remaining command io [#{command_io}]"
    )

    cond do
      String.starts_with?(next_item, "$") ->
        Logger.debug(
          "The next item is a command, returning all of #{command_io} as remaining items."
        )

        {[], [], [next_item | command_io]}

      String.starts_with?(next_item, "dir") ->
        Logger.debug(
          "The next item is a directory entry, parsing the rest of the command sequence first"
        )

        {files, subdirs, uneaten_cmds} = parse_dir_entries(command_io)

        Logger.debug(
          "For directory #{next_item}, our new directory list will be [#{[next_item | subdirs]}]"
        )

        Logger.debug("Are our uneaten commands a list? #{is_list(uneaten_cmds)}")
        {files, [next_item | subdirs], uneaten_cmds}

      true ->
        Logger.debug(
          "The next item is neither command nor directory, so it is a file.  Parsing rest of command sequence first..."
        )

        {files, subdirs, uneaten_cmds} = parse_dir_entries(command_io)
        Logger.debug("For file #{next_item}, our new file list will be [#{[next_item, files]}]")
        Logger.debug("Are our uneaten commands a list? #{is_list(uneaten_cmds)}")
        {[next_item | files], subdirs, uneaten_cmds}
    end
  end

  @spec make_file(list(String.t())) :: list(%{atom() => String.t(), atom() => integer()})
  def make_file([]) do
    []
  end

  def make_file([next_file | tail]) do
    [size_str | [filename | _]] = String.split(next_file)

    case Integer.parse(size_str) do
      :error -> raise("Non-numeric size in file")
      {size, ""} -> [%{filename: filename, size: size} | make_file(tail)]
      {_, _} -> raise("Non-numeric size in file")
    end
  end

  @spec make_dir(String.t(), list(String.t())) :: list(%{atom() => String.t(), atom() => list(), atom() => list()})

  def make_dir("", _) do
    raise "Uninitialized current directory."
  end

  def make_dir(_, []) do
    []
  end

  def make_dir(curr_dir, [next_dir | raw_directories]) do
    case String.split(next_dir, " ", parts: 2) do
      ["dir", dir_name] ->
        Logger.debug("Attaching #{dir_name} to #{curr_dir}")

        [
          %{path: Path.join(curr_dir, dir_name), subdirectories: [], files: []}
          | make_dir(curr_dir, raw_directories)
        ]
    end
  end

  @spec merge_files(
          %{atom() => String.t(), atom() => list(), atom() => list()},
          list(%{atom() => String.t(), atom() => integer()})
        ) ::
          %{atom() => String.t(), atom() => list(), atom() => list()}

  def merge_files(directory, files) do
    Map.replace(directory, :files, Map.get(directory, :files) ++ files)
  end

  @spec merge_subdirs(
          %{atom() => String.t(), atom() => list(), atom() => list()},
          list(%{atom() => String.t(), atom() => list(), atom() => list()})
        ) ::
          %{atom() => String.t(), atom() => list(), atom() => list()}

  def merge_subdirs(directory, subdirs) do
    paths = for subdir <- subdirs, do: Map.get(subdir, :path)
    Map.replace(directory, :subdirectories, Map.get(directory, :subdirectories) ++ paths)
  end
end
