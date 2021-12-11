defmodule Day10 do
  @doc """
  Checks every line for corrupted lines and calculates its score.

  ## Example
      iex> lines = [
      ...>   ["[", "(", "{", "(", "<", "(", "(", ")", ")", "[", "]", ">", "[", "[", "{", "[", "]", "{", "<", "(", ")", "<", ">", ">"],
      ...>   ["[", "(", "(", ")", "[", "<", ">", "]", ")", "]", "(", "{", "[", "<", "{", "<", "<", "[", "]", ">", ">", "("],
      ...>   ["{", "(", "[", "(", "<", "{", "}", "[", "<", ">", "[", "]", "}", ">", "{", "[", "]", "{", "[", "(", "<", "(", ")", ">"],
      ...>   ["(", "(", "(", "(", "{", "<", ">", "}", "<", "{", "<", "{", "<", ">", "}", "{", "[", "]", "{", "[", "]", "{", "}"],
      ...>   ["[", "[", "<", "[", "(", "[", "]", ")", ")", "<", "(", "[", "[", "{", "}", "[", "[", "(", ")", "]", "]", "]"],
      ...>   ["[", "{", "[", "{", "(", "{", "}", "]", "{", "}", "}", "(", "[", "{", "[", "{", "{", "{", "}", "}", "(", "[", "]"],
      ...>   ["{", "<", "[", "[", "]", "]", ">", "}", "<", "{", "[", "{", "[", "{", "[", "]", "{", "(", ")", "[", "[", "[", "]"],
      ...>   ["[", "<", "(", "<", "(", "<", "(", "<", "{", "}", ")", ")", ">", "<", "(", "[", "]", "(", "[", "]", "(", ")"],
      ...>   ["<", "{", "(", "[", "(", "[", "[", "(", "<", ">", "(", ")", ")", "{", "}", "]", ">", "(", "<", "<", "{", "{"],
      ...>   ["<", "{", "(", "[", "{", "{", "}", "}", "[", "<", "[", "[", "[", "<", ">", "{", "}", "]", "]", "]", ">", "[", "]", "]"]
      ...> ]
      iex> Day10.calculate_corruption_score(lines)
      26397
  """
  def calculate_corruption_score(lines) do
    Enum.reduce(lines, 0, fn line, acc ->
      case check_for_corruption(line) do
        result when is_list(result) -> acc
        symbol -> acc + get_score(symbol)
      end
    end)
  end

  @doc """
  Completes every line with the missing symbols and calculates its score.

  ## Example
      iex> lines = [
      ...>   ["[", "(", "{", "(", "<", "(", "(", ")", ")", "[", "]", ">", "[", "[", "{", "[", "]", "{", "<", "(", ")", "<", ">", ">"],
      ...>   ["[", "(", "(", ")", "[", "<", ">", "]", ")", "]", "(", "{", "[", "<", "{", "<", "<", "[", "]", ">", ">", "("],
      ...>   ["{", "(", "[", "(", "<", "{", "}", "[", "<", ">", "[", "]", "}", ">", "{", "[", "]", "{", "[", "(", "<", "(", ")", ">"],
      ...>   ["(", "(", "(", "(", "{", "<", ">", "}", "<", "{", "<", "{", "<", ">", "}", "{", "[", "]", "{", "[", "]", "{", "}"],
      ...>   ["[", "[", "<", "[", "(", "[", "]", ")", ")", "<", "(", "[", "[", "{", "}", "[", "[", "(", ")", "]", "]", "]"],
      ...>   ["[", "{", "[", "{", "(", "{", "}", "]", "{", "}", "}", "(", "[", "{", "[", "{", "{", "{", "}", "}", "(", "[", "]"],
      ...>   ["{", "<", "[", "[", "]", "]", ">", "}", "<", "{", "[", "{", "[", "{", "[", "]", "{", "(", ")", "[", "[", "[", "]"],
      ...>   ["[", "<", "(", "<", "(", "<", "(", "<", "{", "}", ")", ")", ">", "<", "(", "[", "]", "(", "[", "]", "(", ")"],
      ...>   ["<", "{", "(", "[", "(", "[", "[", "(", "<", ">", "(", ")", ")", "{", "}", "]", ">", "(", "<", "<", "{", "{"],
      ...>   ["<", "{", "(", "[", "{", "{", "}", "}", "[", "<", "[", "[", "[", "<", ">", "{", "}", "]", "]", "]", ">", "[", "]", "]"]
      ...> ]
      iex> Day10.calculate_completion_score(lines)
      288957
  """
  def calculate_completion_score(lines) do
    lines
    |> Enum.filter(&is_list(check_for_corruption(&1)))
    |> Enum.map(&get_score(complete_line(&1)))
    |> Enum.sort()
    |> then(&Enum.at(&1, div(length(&1), 2)))
  end

  @doc """
  Checks if line is corrupted.

  ## Example
      iex> line = ["{", "(", "[", "(", "<", "{", "}", "[", "<", ">", "[", "]", "}", ">", "{", "[", "]", "{", "[", "(", "<", "(", ")", ">"]
      iex> Day10.check_for_corruption(line)
      "}"
      iex> line = ["[", "[", "<", "[", "(", "[", "]", ")", ")", "<", "(", "[", "[", "{", "}", "[", "[", "(", ")", "]", "]", "]"]
      iex> Day10.check_for_corruption(line)
      ")"
      iex> line = ["[", "{", "[", "{", "(", "{", "}", "]", "{", "}", "}", "(", "[", "{", "[", "{", "{", "{", "}", "}", "(", "[", "]"]
      iex> Day10.check_for_corruption(line)
      "]"
      iex> line = ["[", "<", "(", "<", "(", "<", "(", "<", "{", "}", ")", ")", ">", "<", "(", "[", "]", "(", "[", "]", "(", ")"]
      iex> Day10.check_for_corruption(line)
      ")"
      iex> line = ["<", "{", "(", "[", "(", "[", "[", "(", "<", ">", "(", ")", ")", "{", "}", "]", ">", "(", "<", "<", "{", "{"]
      iex> Day10.check_for_corruption(line)
      ">"
  """
  def check_for_corruption(line) do
    Enum.reduce_while(line, [], fn
      symbol, acc when symbol in ["(", "{", "[", "<"] -> {:cont, [symbol | acc]}
      ")", ["(" | rest] -> {:cont, rest}
      "}", ["{" | rest] -> {:cont, rest}
      "]", ["[" | rest] -> {:cont, rest}
      ">", ["<" | rest] -> {:cont, rest}
      symbol, _acc -> {:halt, symbol}
    end)
  end

  @doc """
  Completes an incomplete line of symbols.

  ## Example
      iex> line = ["[", "(", "{", "(", "<", "(", "(", ")", ")", "[", "]", ">", "[", "[", "{", "[", "]", "{", "<", "(", ")", "<", ">", ">"]
      iex> Day10.complete_line(line)
      ["}", "}", "]", "]", ")", "}", ")", "]"]
      iex> line = ["[", "(", "(", ")", "[", "<", ">", "]", ")", "]", "(", "{", "[", "<", "{", "<", "<", "[", "]", ">", ">", "("]
      iex> Day10.complete_line(line)
      [")", "}", ">", "]", "}", ")"]
      iex> line = ["(", "(", "(", "(", "{", "<", ">", "}", "<", "{", "<", "{", "<", ">", "}", "{", "[", "]", "{", "[", "]", "{", "}"]
      iex> Day10.complete_line(line)
      ["}", "}", ">", "}", ">", ")", ")", ")", ")"]
      iex> line = ["{", "<", "[", "[", "]", "]", ">", "}", "<", "{", "[", "{", "[", "{", "[", "]", "{", "(", ")", "[", "[", "[", "]"]
      iex> Day10.complete_line(line)
      ["]", "]", "}", "}", "]", "}", "]", "}", ">"]
      iex> line = ["<", "{", "(", "[", "{", "{", "}", "}", "[", "<", "[", "[", "[", "<", ">", "{", "}", "]", "]", "]", ">", "[", "]", "]"]
      iex> Day10.complete_line(line)
      ["]", ")", "}", ">"]
  """
  def complete_line(line) do
    line
    |> check_for_corruption()
    |> Enum.map(fn symbol ->
      case symbol do
        "(" -> ")"
        "{" -> "}"
        "[" -> "]"
        "<" -> ">"
      end
    end)
  end

  @doc """
  Parses the input string into a list of lists of symbols.

  ## Example
      iex> raw_input = "[({(<(())[]>[[{[]{<()<>>\\n[(()[<>])]({[<{<<[]>>(\\n{([(<{}[<>[]}>{[]{[(<()>\\n(((({<>}<{<{<>}{[]{[]{}\\n[[<[([]))<([[{}[[()]]]\\n[{[{({}]{}}([{[{{{}}([]\\n{<[[]]>}<{[{[{[]{()[[[]\\n[<(<(<(<{}))><([]([]()\\n<{([([[(<>()){}]>(<<{{\\n<{([{{}}[<[[[<>{}]]]>[]]\\n"
      iex> Day10.parse_input(raw_input)
      [
        ["[", "(", "{", "(", "<", "(", "(", ")", ")", "[", "]", ">", "[", "[", "{", "[", "]", "{", "<", "(", ")", "<", ">", ">"],
        ["[", "(", "(", ")", "[", "<", ">", "]", ")", "]", "(", "{", "[", "<", "{", "<", "<", "[", "]", ">", ">", "("],
        ["{", "(", "[", "(", "<", "{", "}", "[", "<", ">", "[", "]", "}", ">", "{", "[", "]", "{", "[", "(", "<", "(", ")", ">"],
        ["(", "(", "(", "(", "{", "<", ">", "}", "<", "{", "<", "{", "<", ">", "}", "{", "[", "]", "{", "[", "]", "{", "}"],
        ["[", "[", "<", "[", "(", "[", "]", ")", ")", "<", "(", "[", "[", "{", "}", "[", "[", "(", ")", "]", "]", "]"],
        ["[", "{", "[", "{", "(", "{", "}", "]", "{", "}", "}", "(", "[", "{", "[", "{", "{", "{", "}", "}", "(", "[", "]"],
        ["{", "<", "[", "[", "]", "]", ">", "}", "<", "{", "[", "{", "[", "{", "[", "]", "{", "(", ")", "[", "[", "[", "]"],
        ["[", "<", "(", "<", "(", "<", "(", "<", "{", "}", ")", ")", ">", "<", "(", "[", "]", "(", "[", "]", "(", ")"],
        ["<", "{", "(", "[", "(", "[", "[", "(", "<", ">", "(", ")", ")", "{", "}", "]", ">", "(", "<", "<", "{", "{"],
        ["<", "{", "(", "[", "{", "{", "}", "}", "[", "<", "[", "[", "[", "<", ">", "{", "}", "]", "]", "]", ">", "[", "]", "]"]
      ]
  """
  def parse_input(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  defp get_score(")"), do: 3
  defp get_score("]"), do: 57
  defp get_score("}"), do: 1197
  defp get_score(">"), do: 25137

  defp get_score(symbols) when is_list(symbols) do
    Enum.reduce(symbols, 0, fn symbol, acc ->
      case symbol do
        ")" -> acc * 5 + 1
        "]" -> acc * 5 + 2
        "}" -> acc * 5 + 3
        ">" -> acc * 5 + 4
      end
    end)
  end
end