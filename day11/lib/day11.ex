defmodule Day11 do
  @doc """
  Executes N steps in the given octopuses map.

  ## Example
      iex> octopuses = %{
      ...>   positions: [5,4,8,3,1,4,3,2,2,3,2,7,4,5,8,5,4,7,1,1,5,2,6,4,5,5,6,1,7,3,6,1,4,1,3,3,6,1,4,6,6,3,5,7,3,8,5,4,7,8,4,1,6,7,5,2,4,6,4,5,2,1,7,6,8,4,1,7,2,1,6,8,8,2,8,8,1,1,3,4,4,8,4,6,8,4,8,5,5,4,5,2,8,3,7,5,1,5,2,6],
      ...>   width: 10,
      ...>   height: 10
      ...> }
      iex> result = Day11.execute_steps(octopuses, 10)
      iex> %{total_flashes: 204} = result
      iex> result = Day11.execute_steps(octopuses, 100)
      iex> %{total_flashes: 1656} = result
  """
  def execute_steps(octopuses, steps) do
    Enum.reduce(0..(steps - 1), octopuses, fn _step, acc ->
      execute_step(acc)
    end)
  end

  @doc """
  Finds the first step when all octopuses flash.

  ## Example
      iex> octopuses = %{
      ...>   positions: [5,4,8,3,1,4,3,2,2,3,2,7,4,5,8,5,4,7,1,1,5,2,6,4,5,5,6,1,7,3,6,1,4,1,3,3,6,1,4,6,6,3,5,7,3,8,5,4,7,8,4,1,6,7,5,2,4,6,4,5,2,1,7,6,8,4,1,7,2,1,6,8,8,2,8,8,1,1,3,4,4,8,4,6,8,4,8,5,5,4,5,2,8,3,7,5,1,5,2,6],
      ...>   width: 10,
      ...>   height: 10
      ...> }
      iex> Day11.find_simultaneous_flash(octopuses)
      195
  """
  def find_simultaneous_flash(octopuses, step \\ 0) do
    result = execute_step(octopuses)

    if Enum.sum(result.positions) == 0 do
      step + 1
    else
      find_simultaneous_flash(result, step + 1)
    end
  end

  @doc """
  Executes one step in the given map of octopuses.

  ## Example
      iex> octopuses = %{
      ...>   positions: [1, 1, 1, 1, 1, 1, 9, 9, 9, 1, 1, 9, 1, 9, 1, 1, 9, 9, 9, 1, 1, 1, 1, 1, 1],
      ...>   width: 5,
      ...>   height: 5
      ...> }
      iex> Day11.execute_step(octopuses)
      %{positions: [3, 4, 5, 4, 3, 4, 0, 0, 0, 4, 5, 0, 0, 0, 5, 4, 0, 0, 0, 4, 3, 4, 5, 4, 3], height: 5, width: 5, total_flashes: 9}
  """
  def execute_step(%{width: width, height: height} = octopuses, position, flashed)
      when position >= width * height do
    octopuses =
      Enum.reduce(flashed, octopuses, fn {row, column}, acc ->
        replace_value_at_coordinates(acc, row, column, 0)
      end)

    if needs_to_flash?(octopuses.positions) do
      execute_step(octopuses, 0, flashed)
    else
      Map.update(octopuses, :total_flashes, MapSet.size(flashed), &(&1 + MapSet.size(flashed)))
    end
  end

  def execute_step(octopuses, position, flashed) do
    value = get_value_at_coordinates(octopuses, position)

    if value > 9 do
      {row, column} = position_to_coordinates(octopuses, position)

      octopuses
      |> increment_value_at_coordinates(row + 1, column)
      |> increment_value_at_coordinates(row - 1, column)
      |> increment_value_at_coordinates(row, column + 1)
      |> increment_value_at_coordinates(row, column - 1)
      |> increment_value_at_coordinates(row + 1, column + 1)
      |> increment_value_at_coordinates(row - 1, column - 1)
      |> increment_value_at_coordinates(row + 1, column - 1)
      |> increment_value_at_coordinates(row - 1, column + 1)
      |> execute_step(position + 1, MapSet.put(flashed, {row, column}))
    else
      execute_step(octopuses, position + 1, flashed)
    end
  end

  def execute_step(octopuses) do
    octopuses = Map.put(octopuses, :positions, Enum.map(octopuses.positions, &(&1 + 1)))

    execute_step(octopuses, 0, MapSet.new())
  end

  @doc """
  Parses the string input into a list of integers. Returns a map with the
  positions list and the width of the map.

  ## Example
      iex> raw_input = "11111\\n19991\\n19191\\n19991\\n11111\\n"
      iex> Day11.parse_input(raw_input)
      %{
        positions: [1, 1, 1, 1, 1, 1, 9, 9, 9, 1, 1, 9, 1, 9, 1, 1, 9, 9, 9, 1, 1, 1, 1, 1, 1],
        width: 5,
        height: 5
      }
  """
  def parse_input(raw_input) do
    raw_lines = String.split(raw_input, "\n", trim: true)

    positions =
      raw_lines
      |> Enum.flat_map(&String.split(&1, "", trim: true))
      |> Enum.map(&String.to_integer/1)

    %{
      positions: positions,
      width: byte_size(List.first(raw_lines)),
      height: length(raw_lines)
    }
  end

  defp get_value_at_coordinates(%{positions: positions, width: width}, row, column) do
    Enum.at(positions, row * width + column)
  end

  defp get_value_at_coordinates(octopuses, position) do
    {row, column} = position_to_coordinates(octopuses, position)

    get_value_at_coordinates(octopuses, row, column)
  end

  defp replace_value_at_coordinates(octopuses, row, column, value) do
    %{positions: positions, width: width} = octopuses

    Map.put(octopuses, :positions, List.replace_at(positions, row * width + column, value))
  end

  defp increment_value_at_coordinates(octopuses, row, column) do
    value = get_value_at_coordinates(octopuses, row, column)

    cond do
      is_nil(value) ->
        octopuses

      row >= octopuses.height ->
        octopuses

      column >= octopuses.width ->
        octopuses

      row < 0 ->
        octopuses

      column < 0 ->
        octopuses

      true ->
        replace_value_at_coordinates(
          octopuses,
          row,
          column,
          value + 1
        )
    end
  end

  defp position_to_coordinates(octopuses, position) do
    row = div(position, octopuses.width)
    column = rem(position, octopuses.height)

    {row, column}
  end

  defp needs_to_flash?(positions) do
    Enum.any?(positions, &(&1 > 9))
  end
end
