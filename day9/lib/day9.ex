defmodule Day9 do
  @doc """
  Returns the total risk level of the given heightmap by getting all low points
  and summing everything plue one for each low point.

  ## Example
      iex> positions = [2, 1, 9, 9, 9, 4, 3, 2, 1, 0, 3, 9, 8, 7, 8, 9, 4, 9, 2, 1, 9, 8, 5, 6, 7, 8, 9, 8, 9, 2, 8, 7, 6, 7, 8, 9, 6, 7, 8, 9, 9, 8, 9, 9, 9, 6, 5, 6, 7, 8]
      iex> Day9.get_total_risk_level(%{positions: positions, width: 10, height: 5})
      15
  """
  def get_total_risk_level(heightmap) do
    heightmap
    |> get_low_points()
    |> Enum.reduce(0, &(elem(&1, 1) + 1 + &2))
  end

  @doc """
  Returns a list of all low points values in the heightmap.

  ## Example
      iex> positions = [2, 1, 9, 9, 9, 4, 3, 2, 1, 0, 3, 9, 8, 7, 8, 9, 4, 9, 2, 1, 9, 8, 5, 6, 7, 8, 9, 8, 9, 2, 8, 7, 6, 7, 8, 9, 6, 7, 8, 9, 9, 8, 9, 9, 9, 6, 5, 6, 7, 8]
      iex> Day9.get_low_points(%{positions: positions, width: 10, height: 5})
      [{{0, 1}, 1}, {{0, 9}, 0}, {{2, 2}, 5}, {{4, 6}, 5}]
  """
  def get_low_points(%{positions: positions, width: width, height: height} = heightmap) do
    for row <- 0..(height - 1), column <- 0..(width - 1), is_low_point?(heightmap, row, column) do
      {{row, column}, get_value_at_coodinates(positions, width, row, column)}
    end
  end

  @doc """
  Checks if all adjacent values are higher than the cell value.

  ## Example
      iex> positions = [2, 1, 9, 9, 9, 4, 3, 2, 1, 0, 3, 9, 8, 7, 8, 9, 4, 9, 2, 1, 9, 8, 5, 6, 7, 8, 9, 8, 9, 2, 8, 7, 6, 7, 8, 9, 6, 7, 8, 9, 9, 8, 9, 9, 9, 6, 5, 6, 7, 8]
      iex> heightmap = %{positions: positions, width: 10}
      iex> Day9.is_low_point?(heightmap, 0, 0)
      false
      iex> Day9.is_low_point?(heightmap, 0, 1)
      true
      iex> Day9.is_low_point?(heightmap, 0, 9)
      true
      iex> Day9.is_low_point?(heightmap, 0, 8)
      false
      iex> Day9.is_low_point?(heightmap, 2, 2)
      true
      iex> Day9.is_low_point?(heightmap, 4, 6)
      true
      iex> Day9.is_low_point?(heightmap, 4, 5)
      false
  """
  def is_low_point?(%{positions: positions, width: width}, row, column) do
    value = get_value_at_coodinates(positions, width, row, column)
    up = get_value_at_coodinates(positions, width, row - 1, column) || 10
    right = get_value_at_coodinates(positions, width, row, column + 1) || 10
    down = get_value_at_coodinates(positions, width, row + 1, column) || 10
    left = get_value_at_coodinates(positions, width, row, column - 1) || 10

    value < up and value < right and value < down and value < left
  end

  @doc """
  Returns the cell value in the given heightmap in the row and column provided.

  ## Example
      iex> positions = [2, 1, 9, 9, 9, 4, 3, 2, 1, 0, 3, 9, 8, 7, 8, 9, 4, 9, 2, 1, 9, 8, 5, 6, 7, 8, 9, 8, 9, 2, 8, 7, 6, 7, 8, 9, 6, 7, 8, 9, 9, 8, 9, 9, 9, 6, 5, 6, 7, 8]
      iex> Day9.get_value_at_coodinates(positions, 10, 0, 0)
      2
      iex> Day9.get_value_at_coodinates(positions, 10, 0, 4)
      9
      iex> Day9.get_value_at_coodinates(positions, 10, 1, 2)
      8
      iex> Day9.get_value_at_coodinates(positions, 10, 2, 4)
      7
      iex> Day9.get_value_at_coodinates(positions, 10, 5, 0)
      nil
      iex> Day9.get_value_at_coodinates(positions, 10, 0, 10)
      nil
      iex> Day9.get_value_at_coodinates(positions, 10, -1, 0)
      nil
      iex> Day9.get_value_at_coodinates(positions, 10, 2, -1)
      nil
  """
  def get_value_at_coodinates(_positions, width, _row, column) when column >= width, do: nil
  def get_value_at_coodinates(_positions, _width, row, _column) when row < 0, do: nil
  def get_value_at_coodinates(_positions, _width, _row, column) when column < 0, do: nil

  def get_value_at_coodinates(positions, width, row, column) do
    Enum.at(positions, row * width + column)
  end

  @doc """
  Returns the product of the size of the three largest basins in the heightmap.

  ## Example
      iex> positions = [2, 1, 9, 9, 9, 4, 3, 2, 1, 0, 3, 9, 8, 7, 8, 9, 4, 9, 2, 1, 9, 8, 5, 6, 7, 8, 9, 8, 9, 2, 8, 7, 6, 7, 8, 9, 6, 7, 8, 9, 9, 8, 9, 9, 9, 6, 5, 6, 7, 8]
      iex> heightmap = %{positions: positions, width: 10, height: 5}
      iex> Day9.find_largest_basins(heightmap)
      1134
  """
  def find_largest_basins(heightmap) do
    heightmap
    |> get_low_points()
    |> Enum.map(fn {{row, column}, _value} ->
      heightmap
      |> get_basin(row, column)
      |> MapSet.size()
    end)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.reduce(1, &Kernel.*(&1, &2))
  end

  @doc """
  Returns the basin of a given point in the heightmap.

  ## Example
      iex> positions = [2, 1, 9, 9, 9, 4, 3, 2, 1, 0, 3, 9, 8, 7, 8, 9, 4, 9, 2, 1, 9, 8, 5, 6, 7, 8, 9, 8, 9, 2, 8, 7, 6, 7, 8, 9, 6, 7, 8, 9, 9, 8, 9, 9, 9, 6, 5, 6, 7, 8]
      iex> heightmap = %{positions: positions, width: 10, height: 5}
      iex> Day9.get_basin(heightmap, 0, 0)
      #MapSet<[{0, 0}, {0, 1}, {1, 0}]>
      iex> Day9.get_basin(heightmap, 0, 9)
      #MapSet<[{0, 5}, {0, 6}, {0, 7}, {0, 8}, {0, 9}, {1, 6}, {1, 8}, {1, 9}, {2, 9}]>
      iex> Day9.get_basin(heightmap, 2, 2)
      #MapSet<[{1, 2}, {1, 3}, {1, 4}, {2, 1}, {2, 2}, {2, 3}, {2, 4}, {2, 5}, {3, 0}, {3, 1}, {3, 2}, {3, 3}, {3, 4}, {4, 1}]>
      iex> Day9.get_basin(heightmap, 4, 9)
      #MapSet<[{2, 7}, {3, 6}, {3, 7}, {3, 8}, {4, 5}, {4, 6}, {4, 7}, {4, 8}, {4, 9}]>
  """
  def get_basin(
        %{positions: positions, width: width} = heightmap,
        row,
        column,
        visited \\ MapSet.new()
      ) do
    cond do
      MapSet.member?(visited, {row, column}) ->
        visited

      get_value_at_coodinates(positions, width, row, column) in [nil, 9] ->
        visited

      true ->
        [
          {{row - 1, column}, get_value_at_coodinates(positions, width, row - 1, column)},
          {{row + 1, column}, get_value_at_coodinates(positions, width, row + 1, column)},
          {{row, column - 1}, get_value_at_coodinates(positions, width, row, column - 1)},
          {{row, column + 1}, get_value_at_coodinates(positions, width, row, column + 1)}
        ]
        |> Enum.reject(fn {_position, value} ->
          is_nil(value) and value <= get_value_at_coodinates(positions, width, row, column)
        end)
        |> Enum.reduce(visited, fn {{pos_row, pos_col}, _value}, acc ->
          get_basin(heightmap, pos_row, pos_col, MapSet.put(acc, {row, column}))
        end)
    end
  end

  @doc """
  Parses the string input into a list of integers. Returns a map with the
  heightmap list and the width of the heightmap.

  ## Example
      iex> raw_input = "2199943210\\n3987894921\\n9856789892\\n8767896789\\n9899965678\\n"
      iex> Day9.parse_input(raw_input)
      %{
        positions: [2, 1, 9, 9, 9, 4, 3, 2, 1, 0, 3, 9, 8, 7, 8, 9, 4, 9, 2, 1, 9, 8, 5, 6, 7, 8, 9, 8, 9, 2, 8, 7, 6, 7, 8, 9, 6, 7, 8, 9, 9, 8, 9, 9, 9, 6, 5, 6, 7, 8],
        width: 10,
        height: 5
      }
  """
  def parse_input(raw_input) do
    lines = String.split(raw_input, "\n", trim: true)

    positions =
      lines
      |> Enum.flat_map(&String.split(&1, "", trim: true))
      |> Enum.map(&String.to_integer/1)

    width =
      lines
      |> List.first()
      |> byte_size()

    height = length(lines)

    %{positions: positions, width: width, height: height}
  end
end
