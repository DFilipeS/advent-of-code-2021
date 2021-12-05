defmodule Day5.Bresenham do
  @doc """
  Returns a list of all coordinates between two points using the Bresenham's
  line algorithm (https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm).

  ## Example
      iex> Day5.Bresenham.plot_line([{1, 1}, {1, 3}])
      [{1, 1}, {1, 2}, {1, 3}]
      iex> Day5.Bresenham.plot_line({1, 1}, {1, 3})
      [{1, 1}, {1, 2}, {1, 3}]
      iex> Day5.Bresenham.plot_line({9, 7}, {7, 7})
      [{9, 7}, {8, 7}, {7, 7}]
  """
  def plot_line([coordinate_1, coordinate_2]) do
    plot_line(coordinate_1, coordinate_2)
  end

  def plot_line({x0, y0}, {x1, y1}) do
    dx = abs(x1 - x0)
    dy = -abs(y1 - y0)
    sx = if x0 < x1, do: 1, else: -1
    sy = if y0 < y1, do: 1, else: -1
    err = dx + dy

    plot_line(x0, y0, x1, y1, dx, dy, sx, sy, err)
  end

  defp plot_line(acc \\ [], x0, y0, x1, y1, dx, dy, sx, sy, err)

  defp plot_line(acc, x0, y0, x1, y1, _dx, _dy, _sx, _sy, _err) when x0 == x1 and y0 == y1 do
    acc ++ [{x0, y0}]
  end

  defp plot_line(acc, x0, y0, x1, y1, dx, dy, sx, sy, err) do
    acc = acc ++ [{x0, y0}]
    e2 = 2 * err

    {x0, err} =
      if e2 >= dy do
        err = err + dy
        x0 = x0 + sx
        {x0, err}
      else
        {x0, err}
      end

    {y0, err} =
      if e2 <= dx do
        err = err + dx
        y0 = y0 + sy
        {y0, err}
      else
        {y0, err}
      end

    plot_line(acc, x0, y0, x1, y1, dx, dy, sx, sy, err)
  end
end
