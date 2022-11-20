defmodule Day5 do
  @doc """
  ## Example
      iex> vents = [
      ...>   [{0, 9}, {1, 9}, {2, 9}, {3, 9}, {4, 9}, {5, 9}],
      ...>   [{8, 0}, {7, 1}, {6, 2}, {5, 3}, {4, 4}, {3, 5}, {2, 6}, {1, 7}, {0, 8}],
      ...>   [{9, 4}, {8, 4}, {7, 4}, {6, 4}, {5, 4}, {4, 4}, {3, 4}],
      ...>   [{2, 2}, {2, 1}],
      ...>   [{7, 0}, {7, 1}, {7, 2}, {7, 3}, {7, 4}],
      ...>   [{6, 4}, {5, 3}, {4, 2}, {3, 1}, {2, 0}],
      ...>   [{0, 9}, {1, 9}, {2, 9}],
      ...>   [{3, 4}, {2, 4}, {1, 4}],
      ...>   [{0, 0}, {1, 1}, {2, 2}, {3, 3}, {4, 4}, {5, 5}, {6, 6}, {7, 7}, {8, 8}],
      ...>   [{5, 5}, {6, 4}, {7, 3}, {8, 2}]
      ...> ]
      iex> Day5.total_intersection_points(vents, diagonal: false)
      5
      iex> Day5.total_intersection_points(vents)
      12
  """
  def total_intersection_points(vents, opts \\ [])

  def total_intersection_points(vents, [diagonal: false] = _opts) do
    vents
    |> filter_diagonal_lines()
    |> total_intersection_points()
  end

  def total_intersection_points(vents, _opts) do
    vents
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.reduce([], fn
      {coordinate, count}, acc when count > 1 -> acc ++ [coordinate]
      {_coordinate, _count}, acc -> acc
    end)
    |> length()
  end

  @doc """
  Parses the problem input into a list of coordinates for each cell in each vent
  line.

  ## Example
      iex> raw_input = "0,9 -> 5,9\\n8,0 -> 0,8\\n9,4 -> 3,4\\n2,2 -> 2,1\\n7,0 -> 7,4\\n6,4 -> 2,0\\n0,9 -> 2,9\\n3,4 -> 1,4\\n0,0 -> 8,8\\n5,5 -> 8,2"
      iex> Day5.parse_input(raw_input)
      [
        [{0, 9}, {1, 9}, {2, 9}, {3, 9}, {4, 9}, {5, 9}],
        [{8, 0}, {7, 1}, {6, 2}, {5, 3}, {4, 4}, {3, 5}, {2, 6}, {1, 7}, {0, 8}],
        [{9, 4}, {8, 4}, {7, 4}, {6, 4}, {5, 4}, {4, 4}, {3, 4}],
        [{2, 2}, {2, 1}],
        [{7, 0}, {7, 1}, {7, 2}, {7, 3}, {7, 4}],
        [{6, 4}, {5, 3}, {4, 2}, {3, 1}, {2, 0}],
        [{0, 9}, {1, 9}, {2, 9}],
        [{3, 4}, {2, 4}, {1, 4}],
        [{0, 0}, {1, 1}, {2, 2}, {3, 3}, {4, 4}, {5, 5}, {6, 6}, {7, 7}, {8, 8}],
        [{5, 5}, {6, 4}, {7, 3}, {8, 2}]
      ]
  """
  def parse_input(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_input_line/1)
  end

  defp parse_input_line(raw_input) do
    raw_input
    |> String.split(" -> ", trim: true)
    |> Enum.map(&parse_coordinate/1)
    |> Day5.Bresenham.plot_line()
  end

  defp parse_coordinate(raw_input) do
    raw_input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp filter_diagonal_lines(lines) do
    Enum.filter(lines, fn points ->
      {x0, y0} = List.first(points)
      {x1, y1} = List.last(points)

      x0 == x1 or y0 == y1
    end)
  end
end
