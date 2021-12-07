defmodule Day7 do
  @doc """
  Calculates the minimum fuel required to align all crabs on the same horizontal
  position.

  ## Example
      iex> crabs = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]
      iex> Day7.calculate_minimum_fuel_for_horizontal_alignment(crabs, :simple)
      37
      iex> Day7.calculate_minimum_fuel_for_horizontal_alignment(crabs, :incremental)
      168
  """
  def calculate_minimum_fuel_for_horizontal_alignment(crabs, mode) do
    {min, max} = get_min_and_max_position(crabs)

    min..max
    |> Enum.map(fn position ->
      calculate_fuel_for_position(crabs, position, mode)
    end)
    |> Enum.min()
  end

  @doc """
  Calculates the necessary fuel to move all crabs to the same position.

  ## Example
      iex> crabs = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]
      iex> Day7.calculate_fuel_for_position(crabs, 2, :simple)
      37
      iex> Day7.calculate_fuel_for_position(crabs, 1, :simple)
      41
      iex> Day7.calculate_fuel_for_position(crabs, 3, :simple)
      39
      iex> Day7.calculate_fuel_for_position(crabs, 10, :simple)
      71
      iex> Day7.calculate_fuel_for_position(crabs, 5, :incremental)
      168
      iex> Day7.calculate_fuel_for_position(crabs, 2, :incremental)
      206
  """
  def calculate_fuel_for_position(crabs, position, :simple) do
    crabs
    |> Enum.map(&abs(&1 - position))
    |> Enum.sum()
  end

  def calculate_fuel_for_position(crabs, position, :incremental) do
    crabs
    |> Enum.map(fn crab ->
      n = abs(crab - position) + 1

      div(n * (n - 1), 2)
    end)
    |> Enum.sum()
  end

  @doc """
  Returns the minimum and maximum position of a list of crabs.

  ## Example
      iex> crabs = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]
      iex> Day7.get_min_and_max_position(crabs)
      {0, 16}
  """
  def get_min_and_max_position(crabs) do
    crabs = Enum.sort(crabs)

    {List.first(crabs), List.last(crabs)}
  end

  @doc """
  Parses the input string into a list of integers.

  ## Example
      iex> Day7.parse_input("16,1,2,0,4,2,7,1,2,14\\n")
      [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]
  """
  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
