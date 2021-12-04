defmodule Day3 do
  @doc """
  Calculates the power consumption for a given diagnostics report.

  ## Example
      iex> report = [
      ...>   ["0", "0", "1", "0", "0"],
      ...>   ["1", "1", "1", "1", "0"],
      ...>   ["1", "0", "1", "1", "0"],
      ...>   ["1", "0", "1", "1", "1"],
      ...>   ["1", "0", "1", "0", "1"],
      ...>   ["0", "1", "1", "1", "1"],
      ...>   ["0", "0", "1", "1", "1"],
      ...>   ["1", "1", "1", "0", "0"],
      ...>   ["1", "0", "0", "0", "0"],
      ...>   ["1", "1", "0", "0", "1"],
      ...>   ["0", "0", "0", "1", "0"],
      ...>   ["0", "1", "0", "1", "0"]
      ...> ]
      iex> Day3.calculate_power_consumption(report)
      198
  """
  def calculate_power_consumption(report) do
    frequencies = calculate_all_frequencies_by_position(report)
    gamma_rate = calculate_gamma_rate(frequencies)
    epsilon_rate = calculate_epsilon_rate(frequencies)

    gamma_rate * epsilon_rate
  end

  @doc """
  Calculates the life support rating for a given diagnostics report.

  ## Example
      iex> report = [
      ...>   ["0", "0", "1", "0", "0"],
      ...>   ["1", "1", "1", "1", "0"],
      ...>   ["1", "0", "1", "1", "0"],
      ...>   ["1", "0", "1", "1", "1"],
      ...>   ["1", "0", "1", "0", "1"],
      ...>   ["0", "1", "1", "1", "1"],
      ...>   ["0", "0", "1", "1", "1"],
      ...>   ["1", "1", "1", "0", "0"],
      ...>   ["1", "0", "0", "0", "0"],
      ...>   ["1", "1", "0", "0", "1"],
      ...>   ["0", "0", "0", "1", "0"],
      ...>   ["0", "1", "0", "1", "0"]
      ...> ]
      iex> Day3.calculate_life_support_rating(report)
      230
  """
  def calculate_life_support_rating(report) do
    oxygen_generator_rating = get_oxygen_generator_rating(report)
    co2_scrubber_rating = get_co2_scrubber_rating(report)

    oxygen_generator_rating * co2_scrubber_rating
  end

  @doc """
  Calculates the gamma rate by getting the most frequent bit in each position of
  the string, joining them together and coverting the binary string into a base
  10 integer.

  ## Example
      iex> frequencies = [%{"0" => 5, "1" => 7}, %{"0" => 7, "1" => 5}, %{"0" => 4, "1" => 8}, %{"0" => 5, "1" => 7}, %{"0" => 7, "1" => 5}]
      iex> Day3.calculate_gamma_rate(frequencies)
      22
  """
  def calculate_gamma_rate(frequencies) do
    frequencies
    |> Enum.map(&get_most_frequent_value/1)
    |> Enum.join()
    |> String.to_integer(2)
  end

  @doc """
  Calculates the epsilon rate by getting the least frequent bit in each position
  of the string, joining them together and coverting the binary string into a
  base 10 integer.

  ## Example
      iex> frequencies = [%{"0" => 5, "1" => 7}, %{"0" => 7, "1" => 5}, %{"0" => 4, "1" => 8}, %{"0" => 5, "1" => 7}, %{"0" => 7, "1" => 5}]
      iex> Day3.calculate_epsilon_rate(frequencies)
      9
  """
  def calculate_epsilon_rate(frequencies) do
    frequencies
    |> Enum.map(&get_least_frequent_value/1)
    |> Enum.join()
    |> String.to_integer(2)
  end

  @doc """
  Calculates the frequencies and joins into a single list for all inputs.

  ## Example
      iex> inputs = [
      ...>   ["0", "0", "1", "0", "0"],
      ...>   ["1", "1", "1", "1", "0"],
      ...>   ["1", "0", "1", "1", "0"],
      ...>   ["1", "0", "1", "1", "1"],
      ...>   ["1", "0", "1", "0", "1"],
      ...>   ["0", "1", "1", "1", "1"],
      ...>   ["0", "0", "1", "1", "1"],
      ...>   ["1", "1", "1", "0", "0"],
      ...>   ["1", "0", "0", "0", "0"],
      ...>   ["1", "1", "0", "0", "1"],
      ...>   ["0", "0", "0", "1", "0"],
      ...>   ["0", "1", "0", "1", "0"]
      ...> ]
      iex> Day3.calculate_all_frequencies_by_position(inputs)
      [%{"0" => 5, "1" => 7}, %{"0" => 7, "1" => 5}, %{"0" => 4, "1" => 8}, %{"0" => 5, "1" => 7}, %{"0" => 7, "1" => 5}]
  """
  def calculate_all_frequencies_by_position(inputs) do
    Enum.reduce(inputs, [], &calculate_frequencies_by_position/2)
  end

  @doc """
  Calculates the frequencies of each character in each position of the string.

  ## Example
      iex> Day3.calculate_frequencies_by_position(["0", "0", "1"], [])
      [%{"0" => 1}, %{"0" => 1}, %{"1" => 1}]
      iex> frequencies = [
      ...>   %{"0" => 2, "1" => 3},
      ...>   %{"1" => 5},
      ...>   %{"0" => 4, "1" => 1}
      ...> ]
      iex> Day3.calculate_frequencies_by_position(["0", "0", "1"], frequencies)
      [%{"0" => 3, "1" => 3}, %{"0" => 1, "1" => 5}, %{"0" => 4, "1" => 2}]
  """
  def calculate_frequencies_by_position(input, frequencies) do
    input
    |> Enum.with_index()
    |> Enum.reduce(frequencies, fn {value, index}, acc ->
      frequency =
        acc
        |> Enum.at(index, %{})
        |> Map.update(value, 1, &(&1 + 1))

      if index >= length(acc) do
        acc ++ [frequency]
      else
        List.replace_at(acc, index, frequency)
      end
    end)
  end

  @doc """
  ## Example
      iex> report = [
      ...>   ["0", "0", "1", "0", "0"],
      ...>   ["1", "1", "1", "1", "0"],
      ...>   ["1", "0", "1", "1", "0"],
      ...>   ["1", "0", "1", "1", "1"],
      ...>   ["1", "0", "1", "0", "1"],
      ...>   ["0", "1", "1", "1", "1"],
      ...>   ["0", "0", "1", "1", "1"],
      ...>   ["1", "1", "1", "0", "0"],
      ...>   ["1", "0", "0", "0", "0"],
      ...>   ["1", "1", "0", "0", "1"],
      ...>   ["0", "0", "0", "1", "0"],
      ...>   ["0", "1", "0", "1", "0"]
      ...> ]
      iex> Day3.get_oxygen_generator_rating(report)
      23
  """
  def get_oxygen_generator_rating(report, cycle_count \\ 0)

  def get_oxygen_generator_rating([number], _cycle_count) do
    number
    |> Enum.join()
    |> String.to_integer(2)
  end

  def get_oxygen_generator_rating(report, cycle_count) do
    position = rem(cycle_count, length(List.first(report)))

    value =
      report
      |> calculate_all_frequencies_by_position()
      |> Enum.map(&get_most_frequent_value/1)
      |> Enum.at(position)

    filtered_report = Enum.filter(report, &(Enum.at(&1, position) == value))

    get_oxygen_generator_rating(filtered_report, cycle_count + 1)
  end

  @doc """
  ## Example
      iex> report = [
      ...>   ["0", "0", "1", "0", "0"],
      ...>   ["1", "1", "1", "1", "0"],
      ...>   ["1", "0", "1", "1", "0"],
      ...>   ["1", "0", "1", "1", "1"],
      ...>   ["1", "0", "1", "0", "1"],
      ...>   ["0", "1", "1", "1", "1"],
      ...>   ["0", "0", "1", "1", "1"],
      ...>   ["1", "1", "1", "0", "0"],
      ...>   ["1", "0", "0", "0", "0"],
      ...>   ["1", "1", "0", "0", "1"],
      ...>   ["0", "0", "0", "1", "0"],
      ...>   ["0", "1", "0", "1", "0"]
      ...> ]
      iex> Day3.get_co2_scrubber_rating(report)
      10
  """
  def get_co2_scrubber_rating(report, cycle_count \\ 0)

  def get_co2_scrubber_rating([number], _cycle_count) do
    number
    |> Enum.join()
    |> String.to_integer(2)
  end

  def get_co2_scrubber_rating(report, cycle_count) do
    position = rem(cycle_count, length(List.first(report)))

    value =
      report
      |> calculate_all_frequencies_by_position()
      |> Enum.map(&get_least_frequent_value/1)
      |> Enum.at(position)

    filtered_report = Enum.filter(report, &(Enum.at(&1, position) == value))

    get_co2_scrubber_rating(filtered_report, cycle_count + 1)
  end

  defp get_most_frequent_value(frequencies) do
    frequencies
    |> Enum.into([])
    |> Enum.sort(fn {value_a, count_a}, {value_b, count_b} ->
      if count_a == count_b do
        value_a >= value_b
      else
        count_a >= count_b
      end
    end)
    |> hd()
    |> elem(0)
  end

  defp get_least_frequent_value(frequencies) do
    frequencies
    |> Enum.into([])
    |> Enum.sort(fn {value_a, count_a}, {value_b, count_b} ->
      if count_a == count_b do
        value_a <= value_b
      else
        count_a <= count_b
      end
    end)
    |> hd()
    |> elem(0)
  end

  @doc """
  Parses the problem string input into a list of lists.

  ## Example
      iex> raw_input = "00100\\n11110\\n"
      iex> Day3.parse_input(raw_input)
      [["0", "0", "1", "0", "0"], ["1", "1", "1", "1", "0"]]
  """
  def parse_input(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end
end
