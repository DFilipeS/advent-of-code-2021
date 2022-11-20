defmodule Day4 do
  @board_width 5
  @board_height 5

  @doc """
  Simulates the Bingo draws and calculates the score for the winner board.

  ## Example
      iex> draw = [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24, 10, 16, 13, 6, 15, 25, 12, 22, 18, 20, 8, 19, 3, 26, 1]
      iex> boards = [
      ...>   [22, 13, 17, 11, 0, 8, 2, 23, 4, 24, 21, 9, 14, 16, 7, 6, 10, 3, 18, 5, 1, 12, 20, 15, 19],
      ...>   [3, 15, 0, 2, 22, 9, 18, 13, 17, 5, 19, 8, 7, 25, 23, 20, 11, 10, 24, 4, 14, 21, 16, 12, 6],
      ...>   [14, 21, 17, 24, 4, 10, 16, 15, 9, 19, 18, 8, 23, 26, 20, 22, 11, 13, 6, 5, 2, 0, 12, 3, 7]
      ...> ]
      iex> Day4.calculate_first_winner_score(%{draw: draw, boards: boards})
      4512
  """
  def calculate_first_winner_score(%{draw: draw, boards: boards}) do
    results = simulate_draw(boards, draw)
    [{board, draw_cursor} | _] = results
    score = sum_unmarked_numbers(board, Enum.take(draw, draw_cursor + 1))

    score * Enum.at(draw, draw_cursor)
  end

  @doc """
  Simulates the Bingo draws and calculates the score for the winner board.

  ## Example
      iex> draw = [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24, 10, 16, 13, 6, 15, 25, 12, 22, 18, 20, 8, 19, 3, 26, 1]
      iex> boards = [
      ...>   [22, 13, 17, 11, 0, 8, 2, 23, 4, 24, 21, 9, 14, 16, 7, 6, 10, 3, 18, 5, 1, 12, 20, 15, 19],
      ...>   [3, 15, 0, 2, 22, 9, 18, 13, 17, 5, 19, 8, 7, 25, 23, 20, 11, 10, 24, 4, 14, 21, 16, 12, 6],
      ...>   [14, 21, 17, 24, 4, 10, 16, 15, 9, 19, 18, 8, 23, 26, 20, 22, 11, 13, 6, 5, 2, 0, 12, 3, 7]
      ...> ]
      iex> Day4.calculate_last_winner_score(%{draw: draw, boards: boards})
      1924
  """
  def calculate_last_winner_score(%{draw: draw, boards: boards}) do
    results = simulate_draw(boards, draw)
    {board, draw_cursor} = List.last(results)
    score = sum_unmarked_numbers(board, Enum.take(draw, draw_cursor + 1))

    score * Enum.at(draw, draw_cursor)
  end

  @doc """
  Simulates a regular Bingo draw, with one number getting chosen each turn and
  all the boards checked for winners. Returns all winner boards and the draw turn
  that determined the winners.

  ## Example
      iex> draw = [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24, 10, 16, 13, 6, 15, 25, 12, 22, 18, 20, 8, 19, 3, 26, 1]
      iex> boards = [
      ...>   [22, 13, 17, 11, 0, 8, 2, 23, 4, 24, 21, 9, 14, 16, 7, 6, 10, 3, 18, 5, 1, 12, 20, 15, 19],
      ...>   [3, 15, 0, 2, 22, 9, 18, 13, 17, 5, 19, 8, 7, 25, 23, 20, 11, 10, 24, 4, 14, 21, 16, 12, 6],
      ...>   [14, 21, 17, 24, 4, 10, 16, 15, 9, 19, 18, 8, 23, 26, 20, 22, 11, 13, 6, 5, 2, 0, 12, 3, 7]
      ...> ]
      iex> Day4.simulate_draw(boards, draw)
      [
        {[14, 21, 17, 24, 4, 10, 16, 15, 9, 19, 18, 8, 23, 26, 20, 22, 11, 13, 6, 5, 2, 0, 12, 3, 7], 11},
        {[22, 13, 17, 11, 0, 8, 2, 23, 4, 24, 21, 9, 14, 16, 7, 6, 10, 3, 18, 5, 1, 12, 20, 15, 19], 13},
        {[3, 15, 0, 2, 22, 9, 18, 13, 17, 5, 19, 8, 7, 25, 23, 20, 11, 10, 24, 4, 14, 21, 16, 12, 6], 14}
      ]
  """
  def simulate_draw([], _draw), do: []

  def simulate_draw(boards, draw) do
    0..(length(draw) - 1)
    |> Enum.find_value(fn draw_cursor ->
      with board when is_list(board) <- find_winner_board(boards, draw, draw_cursor) do
        {board, draw_cursor}
      end
    end)
    |> case do
      nil -> []
      result -> [result] ++ simulate_draw(List.delete(boards, elem(result, 0)), draw)
    end
  end

  @doc """
  Returns winner board if any exists.

  ## Example
      iex> draw = [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24, 10, 16, 13, 6, 15, 25, 12, 22, 18, 20, 8, 19, 3, 26, 1]
      iex> boards = [
      ...>   [22, 13, 17, 11, 0, 8, 2, 23, 4, 24, 21, 9, 14, 16, 7, 6, 10, 3, 18, 5, 1, 12, 20, 15, 19],
      ...>   [3, 15, 0, 2, 22, 9, 18, 13, 17, 5, 19, 8, 7, 25, 23, 20, 11, 10, 24, 4, 14, 21, 16, 12, 6],
      ...>   [14, 21, 17, 24, 4, 10, 16, 15, 9, 19, 18, 8, 23, 26, 20, 22, 11, 13, 6, 5, 2, 0, 12, 3, 7]
      ...> ]
      iex> Day4.find_winner_board(boards, draw, 0)
      nil
      iex> Day4.find_winner_board(boards, draw, 11)
      [14, 21, 17, 24, 4, 10, 16, 15, 9, 19, 18, 8, 23, 26, 20, 22, 11, 13, 6, 5, 2, 0, 12, 3, 7]
  """
  def find_winner_board(boards, draw, draw_cursor) do
    Enum.find(boards, fn board ->
      is_winner?(board, Enum.take(draw, draw_cursor + 1))
    end)
  end

  @doc """
  Checks if board is winner with the given drawn numbers.

  ## Example
      iex> board = [14, 21, 17, 24, 4, 10, 16, 15, 9, 19, 18, 8, 23, 26, 20, 22, 11, 13, 6, 5, 2, 0, 12, 3, 7]
      iex> Day4.is_winner?(board, [7, 4, 9, 5, 11])
      false
      iex> Day4.is_winner?(board, [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24])
      true
  """
  def is_winner?(board, drawn_numbers) do
    any_winner_row?(board, drawn_numbers) or any_winner_column?(board, drawn_numbers)
  end

  @doc """
  Returns the cell value in the given board in the row and column provided.

  ## Example
      iex> board = [22, 13, 17, 11, 0, 8, 2, 23, 4, 24, 21, 9, 14, 16, 7, 6, 10, 3, 18, 5, 1, 12, 20, 15, 19]
      iex> Day4.get_value_at_coodinates(board, 0, 0)
      22
      iex> Day4.get_value_at_coodinates(board, 0, 4)
      0
      iex> Day4.get_value_at_coodinates(board, 1, 2)
      23
      iex> Day4.get_value_at_coodinates(board, 2, 4)
      7
  """
  def get_value_at_coodinates(board, row, column) do
    Enum.at(board, row * @board_width + column)
  end

  @doc """
  Returns the sum of the unmarked numbers on a board.

  ## Example
      iex> board = [14, 21, 17, 24, 4, 10, 16, 15, 9, 19, 18, 8, 23, 26, 20, 22, 11, 13, 6, 5, 2, 0, 12, 3, 7]
      iex> drawn_numbers = [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24]
      iex> Day4.sum_unmarked_numbers(board, drawn_numbers)
  """
  def sum_unmarked_numbers(board, drawn_numbers) do
    Enum.reduce(board, 0, fn value, acc ->
      if value not in drawn_numbers do
        acc + value
      else
        acc
      end
    end)
  end

  @doc """
  Parses the problem input into a useful format.

  ## Example
      iex> raw_input = "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1\\n\\n22 13 17 11  0\\n 8  2 23  4 24\\n21  9 14 16  7\\n 6 10  3 18  5\\n 1 12 20 15 19\\n\\n 3 15  0  2 22\\n 9 18 13 17  5\\n19  8  7 25 23\\n20 11 10 24  4\\n14 21 16 12  6\\n\\n14 21 17 24  4\\n10 16 15  9 19\\n18  8 23 26 20\\n22 11 13  6  5\\n 2  0 12  3  7\\n"
      iex> Day4.parse_input(raw_input)
      %{
        draw: [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24, 10, 16, 13, 6, 15, 25, 12, 22, 18, 20, 8, 19, 3, 26, 1],
        boards: [
          [22, 13, 17, 11, 0, 8, 2, 23, 4, 24, 21, 9, 14, 16, 7, 6, 10, 3, 18, 5, 1, 12, 20, 15, 19],
          [3, 15, 0, 2, 22, 9, 18, 13, 17, 5, 19, 8, 7, 25, 23, 20, 11, 10, 24, 4, 14, 21, 16, 12, 6],
          [14, 21, 17, 24, 4, 10, 16, 15, 9, 19, 18, 8, 23, 26, 20, 22, 11, 13, 6, 5, 2, 0, 12, 3, 7]
        ]
      }
  """
  def parse_input(raw_input) do
    [raw_draw | raw_boards] = String.split(raw_input, "\n", trim: true)

    draw =
      raw_draw
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    boards =
      raw_boards
      |> Enum.flat_map(&String.split(&1, " ", trim: true))
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(@board_width * @board_height)

    %{draw: draw, boards: boards}
  end

  defp any_winner_row?(board, drawn_numbers) do
    Enum.any?(0..(@board_height - 1), &is_winner_row?(board, drawn_numbers, &1))
  end

  defp any_winner_column?(board, drawn_numbers) do
    Enum.any?(0..(@board_height - 1), &is_winner_column?(board, drawn_numbers, &1))
  end

  defp is_winner_row?(board, drawn_numbers, row) do
    Enum.reduce(0..(@board_width - 1), true, fn column, acc ->
      acc and get_value_at_coodinates(board, row, column) in drawn_numbers
    end)
  end

  defp is_winner_column?(board, drawn_numbers, column) do
    Enum.reduce(0..(@board_height - 1), true, fn row, acc ->
      acc and get_value_at_coodinates(board, row, column) in drawn_numbers
    end)
  end
end
