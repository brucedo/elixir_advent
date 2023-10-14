defmodule Advent2022Day7Test do
  require Logger
  use ExUnit.Case
  require ExUnit.Assertions
  doctest AdventDay7

  test "given some sequence of files and directories, when fed that sequence, parse_dir_entries will return a tuple containing a list of file entries,
  a list of dir entries, and an empty list representing the consumed directory entries " do

    Logger.debug("Beginning test.")
    dir_entries = ["dir a", "14848514 b.txt", "8504156 c.dat", "dir d"]

    Logger.debug("Starting with list [#{dir_entries}]")

    {files, subdirectories, remaining} = AdventDay7.parse_dir_entries(dir_entries)

    assert length(files) == 2
    assert Enum.member?(files, "14848514 b.txt")
    assert Enum.member?(files, "8504156 c.dat")
    assert length(subdirectories) == 2
    assert Enum.member?(subdirectories, "dir a")
    assert Enum.member?(subdirectories, "dir d")
    assert length(remaining) == 0


  end

  test "given some sequence of files and directories with additional commands following, parse_dir_entries will only consume the files and directories" do
    dir_entries = ["dir a", "14848514 b.txt", "8504156 c.dat", "dir d", "$ cd a", "$ ls"]

    {files, subdirectories, remaining} = AdventDay7.parse_dir_entries(dir_entries)

    assert length(files) == 2
    assert length(subdirectories) == 2
    assert length(remaining) == 2
    assert Enum.member?(remaining, "$ cd a")
    assert Enum.member?(remaining, "$ ls")

  end

  test "given some sequence of files and directories with additional commands following and then more files,
  parse_dir_entries will only consume the first files and directories" do
    dir_entries = ["dir a", "14848514 b.txt", "8504156 c.dat", "dir d", "$ cd a", "$ ls", "dir e", "29116 f"]

    {files, subdirectories, remaining} = AdventDay7.parse_dir_entries(dir_entries)

    assert length(files) == 2
    assert length(subdirectories) == 2
    assert length(remaining) == 4

    assert Enum.member?(remaining, "dir e")
    assert Enum.member?(remaining, "29116 f")

  end

  test "given an empty sequence of command io, parse_dir_entries will produce empty lists" do
    dir_entries = []

    {files, subdirectories, remaining} = AdventDay7.parse_dir_entries(dir_entries)

    assert length(files) == 0
    assert length(subdirectories) == 0
    assert length(remaining) == 0

  end

  test "given a command io sequence that starts with commands and no directories or files,
  parse_dir_entries will leave the command io alone and produce no file/directory lists" do
    dir_entries = ["$ cd a", "$ ls", "dir e", "29116 f"]

    {files, subdirectories, remaining} = AdventDay7.parse_dir_entries(dir_entries)

    assert length(files) == 0
    assert length(subdirectories) == 0
    assert length(remaining) == 4

  end

  test "given a list of strings holding file data make_file will convert them into a list of maps of the form ${:filename => String.t(), :size => integer()}" do
    file_list = ["14848514 b.txt", "8504156 c.dat"]

    files = AdventDay7.make_file(file_list)

    assert length(files) == 2
    assert Enum.member?(files, %{filename: "b.txt", size: 14848514})
    assert Enum.member?(files, %{filename: "c.dat", size: 8504156 })

  end

  test "given a list of strings holding at least one record that is not file formatted make_file will throw an error and fail." do
    file_list = ["14848514 b.txt", "8504156 c.dat", "dir e"]

    ExUnit.Assertions.catch_error AdventDay7.make_file(file_list)

  end

  test "given a list of strings where one file size is not an integer value, make_file will throw an error and fail." do
    file_list = ["85041a c.dat"]

    ExUnit.Assertions.catch_error AdventDay7.make_file(file_list)
  end

  test "given an empty list, make_file will generate an empty list." do
    assert length(AdventDay7.make_file([])) == 0
  end

  test "given a list of strings holding directory data make_dir will convert them into a list of directory structures where each path is prefixed by the current directory" do
    dir_list = ["dir a", "dir d"]
    curr_dir = "/"

    directories = AdventDay7.make_dir(curr_dir, dir_list)

    assert length(directories) == 2

    assert Enum.member?(directories, %{path: "/a", subdirectories: [], files: []})
    assert Enum.member?(directories, %{path: "/d", subdirectories: [], files: []})
  end

  test "given a list of strings where at least one string is not directory formatted make_dir will throw an error and fail." do
    dir_list = ["dir a", "dir d", "8504156 c.dat"]
    curr_dir = "/"

    ExUnit.Assertions.catch_error AdventDay7.make_dir(curr_dir, dir_list)
  end

  test "given an empty list, make_dir will return an empty list." do
    curr_dir = "/"
    assert length(AdventDay7.make_dir(curr_dir, [])) == 0
  end

  test "make_dir will work for curr_dir values that are not just the root directory" do
    curr_dir = "/a/b/c/d/e/f"
    dir_list = ["dir a", "dir c"]

    directories = AdventDay7.make_dir(curr_dir, dir_list)

    Logger.debug("#{List.first(directories) |> Map.get(:path)}")

    assert length(directories) == 2


    # Logger.debug("#{List.last(directories) |> Map.get(:path)}")

    assert Enum.member?(directories, %{path: "/a/b/c/d/e/f/a", subdirectories: [], files: []})
    assert Enum.member?(directories, %{path: "/a/b/c/d/e/f/c", subdirectories: [], files: []})
  end

  test "make_dir will operate on a curr_dir that ends in a / as well" do
    curr_dir = "/a/b/c/d/e/f/"
    dir_list = ["dir a", "dir c"]

    directories = AdventDay7.make_dir(curr_dir, dir_list)

    assert length(directories) == 2

    assert Enum.member?(directories, %{path: "/a/b/c/d/e/f/a", subdirectories: [], files: []})
    assert Enum.member?(directories, %{path: "/a/b/c/d/e/f/c", subdirectories: [], files: []})
  end

  test "if curr_dir is not initialized then make_dir will raise an error." do
    ExUnit.Assertions.catch_error(AdventDay7.make_dir("", ["dir a", "dir b"]))
  end

  test "given a list of file objects and a directory object, merge_files will merge the files into the directory object and return it." do
    directory = %{path: "/a/b/c/d/e", subdirectories: [], files: []}
    files = [%{filename: "b.txt", size: 14848514}, %{filename: "c.dat", size: 8504156 }]

    merged = AdventDay7.merge_files(directory, files)

    assert Map.get(merged, :files) |> length == 2

    assert Map.get(merged, :files) |> List.first() |> Map.get(:filename) == "b.txt"
    assert Map.get(merged, :files) |> List.last() |> Map.get(:filename) == "c.dat"

  end

  test "given an empty list instead of a list of file objects, merge_files will return a directory object with an empty file list" do
    directory = %{path: "/a/b/c/d/e", subdirectories: [], files: []}
    files = []

    merged = AdventDay7.merge_files(directory, files)

    assert Map.get(merged, :files) |> length == 0
  end

  test "given a list of child directories and a parent directory, merge_subdirs will return a directory object matching the parent but with the
  subdirectory list filled with the paths of the child directories provided." do
    directory = %{path: "/a/b/c/d/e/f", subdirectories: [], files: []}
    subdirectories = [%{path: "/a/b/c/d/e/f/a", subdirectories: [], files: []}, %{path: "/a/b/c/d/e/f/c", subdirectories: [], files: []}]

    merged = AdventDay7.merge_subdirs(directory, subdirectories)

    assert Map.get(merged, :subdirectories) |> length == 2

    assert Map.get(merged, :subdirectories) |> Enum.member?("/a/b/c/d/e/f/a")
    assert Map.get(merged, :subdirectories) |> Enum.member?("/a/b/c/d/e/f/c")

  end

  test "given a an empty list of child directories and a parent directory, merge_subdirs will return a directory object matching the parent" do
    directory = %{path: "/a/b/c/d/e/f", subdirectories: [], files: []}

    merged = AdventDay7.merge_subdirs(directory, [])

    assert merged == directory
  end


  test "given some stream of commands and their output, process_dir_tree will produce a map with all of the directories and files described" do
    commands = ["$ cd /",
      "$ ls",
      "dir a",
      "14848514 b.txt",
      "8504156 c.dat",
      "dir d",
      "$ cd a",
      "$ ls",
      "dir e",
      "29116 f",
      "2557 g",
      "62596 h.lst",
      "$ cd e",
      "$ ls",
      "584 i",
      "$ cd ..",
      "$ cd ..",
      "$ cd d",
      "$ ls",
      "4060174 j",
      "8033020 d.log",
      "5626152 d.ext",
      "7214296 k"]

      dir_tree = AdventDay7.process_dir_tree(commands, "")

      assert map_size(dir_tree) == 4

      assert Map.get(dir_tree, "/") == %{path: "/", subdirectories: ["/a", "/d"], files: [%{filename: "b.txt", size: 14848514}, %{filename: "c.dat", size: 8504156}]}
      assert Map.get(dir_tree, "/a") == %{path: "/a", subdirectories: ["/a/e"], files: [%{filename: "f", size: 29116}, %{filename: "g", size: 2557}, %{filename: "h.lst", size: 62596}]}
      assert Map.get(dir_tree, "/a/e") == %{path: "/a/e", subdirectories: [], files: [%{filename: "i", size: 584}]}
      assert Map.get(dir_tree, "/d") == %{path: "/d", subdirectories: [], files: [%{filename: "j", size: 4060174}, %{filename: "d.log", size: 8033020}, %{filename: "d.ext", size: 5626152}, %{filename: "k", size: 7214296}]}
  end

  test "given an empty list of commands, process_dir_tree will generate an empty map." do
    assert AdventDay7.process_dir_tree([], "") == %{}
  end

  test "given a map of a directory structure and an integer cutoff, filter_by_size will return a list of all directory sizes less than or equal to cutoff" do
    cutoff = 100000

    directories = %{
      "/" => %{path: "/", subdirectories: ["/a", "/d"], files: [%{filename: "b.txt", size: 14848514}, %{filename: "c.dat", size: 8504156}]},
      "/a" => %{path: "/a", subdirectories: ["/a/e"], files: [%{filename: "f", size: 29116}, %{filename: "g", size: 2557}, %{filename: "h.lst", size: 62596}]},
      "/a/e" => %{path: "/a/e", subdirectories: [], files: [%{filename: "i", size: 584}]},
      "/d" => %{path: "/d", subdirectories: [], files: [%{filename: "j", size: 4060174}, %{filename: "d.log", size: 8033020}, %{filename: "d.ext", size: 5626152}, %{filename: "k", size: 7214296}]}
    }


    sizes_lower_than_100k = AdventDay7.filter_by_size(directories, cutoff)

    assert length(sizes_lower_than_100k) == 2
    assert Enum.member?(sizes_lower_than_100k, 584)
    assert Enum.member?(sizes_lower_than_100k, 94853)
  end


end
