defmodule Common do

  def open({:error, _msg}, _)
  do
    raise File.Error, message: "Could not open file."
  end

  def open({:ok, working_dir}, filename)
  do
    Path.join(working_dir, filename) |> File.open([:read, :utf8])
  end

  def close({:ok, dev})
  do
    File.close(dev)
  end

  def read_file({:error, _msg})
  do
    raise IO.StreamError, message: "Input stream could not be created."
  end

  def read_file({:ok, stream})
  do
    IO.stream(stream, :line) |> Enum.map(fn line -> String.trim(line) end)
  end
end
