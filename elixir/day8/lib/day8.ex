defmodule Day8 do
  @doc """
  Builds up a lookup table of the product of the intersections of each number
  with the "easy digits" that have a unique length in segments (1, 4, 7 and 8).

  ## Example
      iex> Day8.build_lookup_table()
      %{20 => 2, 30 => 5, 36 => 6, 90 => 3, 108 => 0, 144 => 9}
  """
  def build_lookup_table do
    %{
      # 1  4   7   8
      (2 * 3 * 3 * 6) => 0,
      (1 * 2 * 2 * 5) => 2,
      (2 * 3 * 3 * 5) => 3,
      (1 * 3 * 2 * 5) => 5,
      (1 * 3 * 2 * 6) => 6,
      (2 * 4 * 3 * 6) => 9
    }
  end

  @doc """
  Returns the total sum of all output values.

  ## Example
      iex> inputs = [
      ...>   ["be", "cfbegad", "cbdgef", "fgaecd", "cgeb", "fdcge", "agebfd", "fecdb", "fabcd", "edb", "fdgacbe", "cefdb", "cefbgd", "gcbe"],
      ...>   ["edbfga", "begcd", "cbg", "gc", "gcadebf", "fbgde", "acbgfd", "abcde", "gfcbed", "gfec", "fcgedb", "cgb", "dgebacf", "gc"],
      ...>   ["fgaebd", "cg",  "bdaec",  "gdafb",  "agbcfd",  "gdcbef",  "bgcad",  "gfac",  "gcb",  "cdgabef",  "cg",  "cg",  "fdcagb",  "cbg"],
      ...>   ["fbegcd",  "cbd",  "adcefb",  "dageb",  "afcb",  "bc",  "aefdc",  "ecdab",  "fgdeca",  "fcdbega",  "efabcd",  "cedba",  "gadfec", "cb"],
      ...>   ["aecbfdg",  "fbg",  "gf",  "bafeg",  "dbefa",  "fcge",  "gcbea",  "fcaegb",  "dgceab",  "fcbdga",  "gecf",  "egdcabf",  "bgf", "bfgea"],
      ...>   ["fgeab",  "ca",  "afcebg",  "bdacfeg",  "cfaedg",  "gcfdb",  "baec",  "bfadeg",  "bafgc",  "acf",  "gebdcfa",  "ecba",  "ca", "fadegcb"],
      ...>   ["dbcfg",  "fgd",  "bdegcaf",  "fgec",  "aegbdf",  "ecdfab",  "fbedc",  "dacgb",  "gdcebf",  "gf",  "cefg",  "dcbef",  "fcge", "gbcadfe"],
      ...>   ["bdfegc",  "cbegaf",  "gecbf",  "dfcage",  "bdacg",  "ed",  "bedf",  "ced",  "adcbefg",  "gebcd",  "ed",  "bcgafe",  "cdgba", "cbgef"],
      ...>   ["egadfb",  "cdbfeg",  "cegd",  "fecab",  "cgb",  "gbdefca",  "cg",  "fgcdab",  "egfdb",  "bfceg",  "gbdfcae",  "bgc",  "cg", "cgb"],
      ...>   ["gcafb",  "gcf",  "dcaebfg",  "ecagb",  "gf",  "abcdeg",  "gaef",  "cafbge",  "fdbac",  "fegbdc",  "fgae",  "cfgab",  "fg", "bagce"]
      ...> ]
      iex> Day8.get_total_output_value(inputs)
      61229
  """
  def get_total_output_value(inputs) do
    Enum.reduce(inputs, 0, &(get_output_value(&1) + &2))
  end

  @doc """
  Returns an integer that represents the output value.

  ## Example
      iex> input = ["acedgfb", "cdfbe", "gcdfa", "fbcad", "dab", "cefabd", "cdfgeb", "eafb", "cagedb", "ab", "cdfeb", "fcadb", "cdfeb", "cdbaf"]
      iex> Day8.get_output_value(input)
      5353
  """
  def get_output_value(input) do
    input
    |> Enum.take(-4)
    |> Enum.map(fn encoded_number ->
      translate_to_number(input, encoded_number)
    end)
    |> Integer.undigits()
  end

  @doc """
  Converts the given string into a number using the lookup table.

  ## Example
      iex> input = ["acedgfb", "cdfbe", "gcdfa", "fbcad", "dab", "cefabd", "cdfgeb", "eafb", "cagedb", "ab", "cdfeb", "fcadb", "cdfeb", "cdbaf"]
      iex> Day8.translate_to_number(input, "cdfeb")
      5
      iex> Day8.translate_to_number(input, "fcadb")
      3
      iex> Day8.translate_to_number(input, "cdbaf")
      3
      iex> input = ["fbegcd",  "cbd",  "adcefb",  "dageb",  "afcb",  "bc",  "aefdc",  "ecdab",  "fgdeca",  "fcdbega",  "efabcd",  "cedba",  "gadfec", "cb"]
      iex> Day8.translate_to_number(input, "gadfec")
      6
  """
  def translate_to_number(_input, encoded_number) when byte_size(encoded_number) == 2, do: 1
  def translate_to_number(_input, encoded_number) when byte_size(encoded_number) == 4, do: 4
  def translate_to_number(_input, encoded_number) when byte_size(encoded_number) == 3, do: 7
  def translate_to_number(_input, encoded_number) when byte_size(encoded_number) == 7, do: 8

  def translate_to_number(input, encoded_number) do
    encoded_number_set = create_number_set(encoded_number)

    lookup_value =
      Enum.reduce([1, 4, 7, 8], 1, fn value, acc ->
        MapSet.intersection(encoded_number_set, find_encoded_number(input, value))
        |> MapSet.size()
        |> Kernel.*(acc)
      end)

    Map.get(build_lookup_table(), lookup_value)
  end

  @doc """
  Returns an integer of the total amount of easy digits on the input outputs.

  ## Example
      iex> inputs = [
      ...>   ["be", "cfbegad", "cbdgef", "fgaecd", "cgeb", "fdcge", "agebfd", "fecdb", "fabcd", "edb", "fdgacbe", "cefdb", "cefbgd", "gcbe"],
      ...>   ["edbfga", "begcd", "cbg", "gc", "gcadebf", "fbgde", "acbgfd", "abcde", "gfcbed", "gfec", "fcgedb", "cgb", "dgebacf", "gc"],
      ...> ]
      iex> Day8.get_total_unique_digits(inputs)
      5
  """
  def get_total_unique_digits(inputs) do
    Enum.reduce(inputs, 0, fn input, acc ->
      input
      |> Enum.take(-4)
      |> find_unique_digits()
      |> length()
      |> Kernel.+(acc)
    end)
  end

  @doc """
  Finds any easy digits (1, 4, 7, 8) in a list of input strings.

  ## Example
      iex> digits = ["fdgacbe", "cefdb", "cefbgd", "gcbe"]
      iex> Day8.find_unique_digits(digits)
      ["fdgacbe", "gcbe"]
      iex> digits = ["fcgedb", "cgb", "dgebacf", "gc"]
      iex> Day8.find_unique_digits(digits)
      ["cgb", "dgebacf", "gc"]
  """
  def find_unique_digits(digits) do
    Enum.filter(digits, &is_unique_digit?/1)
  end

  @doc """
  Parses the input string and returns a list of maps.

  ## Example
      iex> raw_input = "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe\\nedbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc\\n"
      iex> Day8.parse_input(raw_input)
      [
        ["be", "cfbegad", "cbdgef", "fgaecd", "cgeb", "fdcge", "agebfd", "fecdb", "fabcd", "edb", "fdgacbe", "cefdb", "cefbgd", "gcbe"],
        ["edbfga", "begcd", "cbg", "gc", "gcadebf", "fbgde", "acbgfd", "abcde", "gfcbed", "gfec", "fcgedb", "cgb", "dgebacf", "gc"],
      ]
  """
  def parse_input(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
    |> Enum.map(fn input ->
      String.split(input, [" | ", " "])
    end)
  end

  defp is_unique_digit?(digit) do
    cond do
      String.length(digit) == 2 -> true
      String.length(digit) == 4 -> true
      String.length(digit) == 3 -> true
      String.length(digit) == 7 -> true
      true -> false
    end
  end

  defp find_encoded_number(input, 1) do
    input
    |> Enum.find(&(byte_size(&1) == 2))
    |> create_number_set()
  end

  defp find_encoded_number(input, 4) do
    input
    |> Enum.find(&(byte_size(&1) == 4))
    |> create_number_set()
  end

  defp find_encoded_number(input, 7) do
    input
    |> Enum.find(&(byte_size(&1) == 3))
    |> create_number_set()
  end

  defp find_encoded_number(input, 8) do
    input
    |> Enum.find(&(byte_size(&1) == 7))
    |> create_number_set()
  end

  defp create_number_set(encoded_number) do
    encoded_number
    |> String.split("", trim: true)
    |> MapSet.new()
  end
end
