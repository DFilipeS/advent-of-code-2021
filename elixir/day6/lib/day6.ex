defmodule Day6 do
  @doc """
  Returns the total amount of fishes after n days.

  ## Example
      iex> fishes = %{1 => 1, 2 => 1, 3 => 2, 4 => 1}
      iex> Day6.total_fishes_after_days(fishes, 18)
      26
      iex> Day6.total_fishes_after_days(fishes, 80)
      5934
      iex> Day6.total_fishes_after_days(fishes, 256)
      26984457539
  """
  def total_fishes_after_days(fishes, days) do
    fishes
    |> simulate_days(days)
    |> sum_total_fishes()
  end

  @doc """
  Simulates n days of the life of fishes. Returns a list of fishes on the nth
  day.

  ## Example
      iex> fishes = %{1 => 1, 2 => 1, 3 => 2, 4 => 1}
      iex> Day6.simulate_days(fishes, 10)
      %{0 => 3, 1 => 2, 2 => 2, 3 => 1, 5 => 1, 6 => 1, 7 => 1, 8 => 1}
      iex> Day6.simulate_days(fishes, 15)
      %{0 => 1, 1 => 1, 2 => 4, 3 => 3, 4 => 5, 5 => 3, 6 => 2, 7 => 1}
  """
  def simulate_days(fishes, days) do
    Enum.reduce(1..days, fishes, fn _day, fishes -> simulate_day(fishes) end)
  end

  @doc """
  Simulates a day of the life of fishes. Returns a map of fishes in the next
  day.

  ## Example
      iex> fishes = %{1 => 1, 2 => 1, 3 => 2, 4 => 1}
      iex> fishes = Day6.simulate_day(fishes)
      %{0 => 1, 1 => 1, 2 => 2, 3 => 1}
      iex> fishes = Day6.simulate_day(fishes)
      %{0 => 1, 1 => 2, 2 => 1, 6 => 1, 8 => 1}
      iex> Day6.simulate_day(fishes)
      %{0 => 2, 1 => 1, 5 => 1, 6 => 1, 7 => 1, 8 => 1}
  """
  def simulate_day(fishes) do
    Enum.reduce(fishes, %{}, fn
      {0, count}, acc ->
        acc
        |> Map.update(6, count, &(&1 + count))
        |> Map.update(8, count, &(&1 + count))

      {age, count}, acc ->
        Map.update(acc, age - 1, count, &(&1 + count))
    end)
  end

  @doc """
  Parses the problem string input into a list of integers.

  ## Example
      iex> raw_input = "3,4,3,1,2\\n"
      iex> Day6.parse_input(raw_input)
      %{1 => 1, 2 => 1, 3 => 2, 4 => 1}
  """
  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end

  defp sum_total_fishes(fishes) do
    Enum.reduce(fishes, 0, fn {_age, count}, acc -> acc + count end)
  end
end
