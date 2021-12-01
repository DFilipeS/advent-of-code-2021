defmodule Commons do
  @doc """
  Reads a file input from the `priv` directory and returns a string with the
  file contents.
  """
  def read_input(app_name, file_name \\ "input.txt") do
    app_name
    |> :code.priv_dir()
    |> Path.join(file_name)
    |> File.read!()
  end
end
