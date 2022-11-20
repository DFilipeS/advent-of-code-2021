defmodule Day2 do
  @doc """
  Calculates the horizontal position and depth you would have after following
  the planned course and multiplies both values.

  ## Example
      iex> plan = [
      ...>   %{direction: "forward", amount: 5},
      ...>   %{direction: "down", amount: 5},
      ...>   %{direction: "forward", amount: 8},
      ...>   %{direction: "up", amount: 3},
      ...>   %{direction: "down", amount: 8},
      ...>   %{direction: "forward", amount: 2}
      ...> ]
      iex> Day2.calculate_and_multiply_position(plan, aim: false)
      150
      iex> Day2.calculate_and_multiply_position(plan, aim: true)
      900
  """
  def calculate_and_multiply_position(plan, opts) do
    position = calculate_position(plan, opts)
    horizontal_pos = elem(position, 0)
    depth = elem(position, 1)

    horizontal_pos * depth
  end

  @doc """
  Calculates the horizontal position and depth you would have after following
  the planned course.

  ## Example
      iex> plan = [
      ...>   %{direction: "forward", amount: 5},
      ...>   %{direction: "down", amount: 5},
      ...>   %{direction: "forward", amount: 8},
      ...>   %{direction: "up", amount: 3},
      ...>   %{direction: "down", amount: 8},
      ...>   %{direction: "forward", amount: 2}
      ...> ]
      iex> Day2.calculate_position(plan, aim: false)
      {15, 10}
      iex> Day2.calculate_position(plan, aim: true)
      {15, 60, 10}
  """
  def calculate_position(plan, aim: true) do
    Enum.reduce(plan, {0, 0, 0}, fn
      %{direction: "forward", amount: amount}, {horizontal_pos, depth, aim} ->
        {horizontal_pos + amount, depth + aim * amount, aim}

      %{direction: "down", amount: amount}, {horizontal_pos, depth, aim} ->
        {horizontal_pos, depth, aim + amount}

      %{direction: "up", amount: amount}, {horizontal_pos, depth, aim} ->
        {horizontal_pos, depth, aim - amount}
    end)
  end

  def calculate_position(plan, _opts) do
    Enum.reduce(plan, {0, 0}, fn
      %{direction: "forward", amount: amount}, {horizontal_pos, depth} ->
        {horizontal_pos + amount, depth}

      %{direction: "down", amount: amount}, {horizontal_pos, depth} ->
        {horizontal_pos, depth + amount}

      %{direction: "up", amount: amount}, {horizontal_pos, depth} ->
        {horizontal_pos, depth - amount}
    end)
  end

  @doc """
  Parses the problem string input into a list of commands.

  ## Example
      iex> raw_input = "forward 5\\ndown 5\\nforward 8"
      iex> Day2.parse_input(raw_input)
      [%{direction: "forward", amount: 5}, %{direction: "down", amount: 5}, %{direction: "forward", amount: 8}]
  """
  def parse_input(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
    |> Enum.map(fn input ->
      [direction, amount] = String.split(input)
      %{direction: direction, amount: String.to_integer(amount)}
    end)
  end
end
