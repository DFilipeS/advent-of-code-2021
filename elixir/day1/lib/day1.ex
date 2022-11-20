defmodule Day1 do
  @doc """
  Counts the number of times a depth measurement increases from the previous
  measurement. There is no measurement before the first measurement.

  ## Example
      iex> measurements = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
      iex> Day1.total_measurements_increases(measurements)
      7
  """
  def total_measurements_increases(measurements) do
    measurements
    |> Enum.reduce({-1, -1}, &check_measurement/2)
    |> elem(0)
  end

  @doc """
  Counts the number of times the sum of measurements in a three measurements
  long sliding window increases from the previous one.

  ## Example
      iex> measurements = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
      iex> Day1.total_sliding_window_measurements_increases(measurements)
      5
  """
  def total_sliding_window_measurements_increases(measurements) do
    Enum.reduce_while(
      0..length(measurements),
      {-1, -1},
      &check_sliding_window_measurement(measurements, &1, &2)
    )
  end

  @doc """
  Parses the problem string input into a list of integers.

  ## Example
      iex> raw_input = "199\\n200\\n208\\n210\\n200\\n"
      iex> Day1.parse_input(raw_input)
      [199, 200, 208, 210, 200]
  """
  def parse_input(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp check_measurement(current, {counter, last}) when current > last do
    {counter + 1, current}
  end

  defp check_measurement(current, {counter, _last}) do
    {counter, current}
  end

  defp check_sliding_window_measurement(measurements, index, {counter, _last_window_sum})
       when index > length(measurements) - 3 do
    {:halt, counter}
  end

  defp check_sliding_window_measurement(measurements, index, {counter, last_window_sum}) do
    window_sum = calculate_window_sum(measurements, index)

    if window_sum > last_window_sum do
      {:cont, {counter + 1, window_sum}}
    else
      {:cont, {counter, window_sum}}
    end
  end

  defp calculate_window_sum(measurements, index) do
    measurements
    |> build_window(index)
    |> Enum.sum()
  end

  defp build_window(measurements, index) do
    [
      Enum.at(measurements, index),
      Enum.at(measurements, index + 1),
      Enum.at(measurements, index + 2)
    ]
  end
end
